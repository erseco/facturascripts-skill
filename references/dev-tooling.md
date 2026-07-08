# Ecosistema de desarrollo, pruebas y publicacion de plugins

Esta referencia documenta el conjunto de herramientas que rodean al desarrollo de
plugins de FacturaScripts y que permiten **arrancar un proyecto en minutos**,
**probar un plugin o un PR en el navegador sin instalar nada** y **automatizar el
release a la forja oficial**. Son cuatro piezas que encajan entre si:

| Pieza | Repositorio | Que aporta |
| --- | --- | --- |
| Imagen Docker base | [erseco/alpine-facturascripts](https://github.com/erseco/alpine-facturascripts) | Imagen ligera (~30MB, Alpine + PHP 8.4) con instalacion desatendida; es la base del entorno de desarrollo y CI |
| Plantilla de plugin | [erseco/facturascripts-plugin-template](https://github.com/erseco/facturascripts-plugin-template) | Esqueleto de plugin con Docker, tests, lint y workflows de CI/release listos |
| Playground (WASM) | [erseco/facturascripts-playground](https://github.com/erseco/facturascripts-playground) | FacturaScripts completo corriendo en el navegador con `@php-wasm/web`; configurable con `blueprint.json` |
| Action: PR Preview | [erseco/action-facturascripts-playground-pr-preview](https://github.com/erseco/action-facturascripts-playground-pr-preview) | Publica en cada PR un enlace "Probar en el Playground" generado desde un `blueprint.json` |
| Action: Publicar en la forja | [erseco/action-facturascripts-publicar-forja](https://github.com/erseco/action-facturascripts-publicar-forja) | Sube el ZIP del plugin como nuevo build a `facturascripts.com/forja` tras una release |

Usa esta referencia cuando el usuario quiera: **crear un plugin desde cero con
buenas practicas**, **montar un entorno de pruebas reproducible**, **dar a un
revisor una demo en vivo de un PR**, o **automatizar la publicacion** de versiones.

Los archivos listos para copiar estan en `templates/` (workflows, `blueprint.json`).

---

## 0. Imagen Docker base: `alpine-facturascripts`

Imagen Docker ligera (~30 MB) de FacturaScripts sobre Alpine Linux con **PHP 8.4
FPM** y nginx. Es la base sobre la que corre el entorno de desarrollo de la plantilla
(`erseco/alpine-facturascripts:main` en su `docker-compose.yml`) y el CI. Disponible en
Docker Hub (`erseco/alpine-facturascripts`) y GHCR (`ghcr.io/erseco/alpine-facturascripts`).

### 0.1 Por que importa para el desarrollo de plugins

Su gran ventaja es la **instalacion desatendida**: con unas pocas variables de entorno
arranca un FacturaScripts ya configurado (empresa, plan contable, usuario admin), sin
pasar por el wizard web. Esto la hace ideal para entornos reproducibles, demos y CI.

- Multi-arch (`amd64`, `arm64`, `arm/v7`...), servicios bajo usuario no privilegiado.
- PHP-FPM `ondemand` (solo consume con trafico), runit, logs a STDOUT.
- Cron horario para las tareas de FacturaScripts (desactivable).

### 0.2 Variables de entorno clave

| Variable | Para que |
| --- | --- |
| `DB_TYPE` / `DB_HOST` / `DB_PORT` / `DB_NAME` / `DB_USER` / `DB_PASSWORD` | Conexion a BD (MySQL/PostgreSQL) |
| `FS_INITIAL_USER` / `FS_INITIAL_PASS` | **Obligatorias** para instalacion desatendida (si faltan, sale el wizard) |
| `FS_LANG` / `FS_TIMEZONE` | Idioma y zona horaria |
| `FS_DEBUG` | Modo debug |
| `FS_CODPAIS` / `FS_COMPANY_NAME` / `FS_COMPANY_CIF` / `FS_COMPANY_REGIMENIVA` | Datos de empresa para el auto-setup |
| `FS_LOAD_ACCOUNTING_PLAN` | Importar plan contable por defecto |
| `FS_SEED_FILE` | Ruta a un JSON de datos demo (proveedores, productos...) |
| `FS_PLUGINS` | Lista (separada por espacios) de plugins a instalar en el primer arranque: nombre, id de descarga o URL |
| `RUN_CRON_TASKS` / `CRON_INTERVAL` | Activar/programar las tareas cron (en dev se suele poner `false`) |
| `PRE_CONFIGURE_COMMANDS` / `POST_CONFIGURE_COMMANDS` | Hooks antes/despues de la configuracion |
| `FS_VERSION` (build arg) | Fijar una version concreta de FacturaScripts al construir la imagen |

Conceptos paralelos al blueprint del Playground: `FS_PLUGINS` ~ `plugins`,
`FS_SEED_FILE` ~ `seed`, las `FS_COMPANY_*`/`FS_CODPAIS` ~ `install`. La diferencia es
que aqui corre PHP real sobre MariaDB/MySQL en un contenedor, no WASM en el navegador.

### 0.3 Uso minimo

```yaml
services:
  mariadb:
    image: mariadb:lts
    environment:
      MYSQL_ROOT_PASSWORD: facturascripts
      MYSQL_DATABASE: facturascripts
      MYSQL_USER: facturascripts
      MYSQL_PASSWORD: facturascripts
  facturascripts:
    image: erseco/alpine-facturascripts:latest
    ports: ["8080:8080"]
    environment:
      DB_HOST: mariadb
      DB_NAME: facturascripts
      DB_USER: facturascripts
      DB_PASSWORD: facturascripts
      FS_INITIAL_USER: admin
      FS_INITIAL_PASS: ChangeMe123!
      FS_LANG: es_ES
      FS_TIMEZONE: Europe/Madrid
      FS_PLUGINS: "verifactu multiempresa"   # opcional: instala en el primer arranque
    depends_on: [mariadb]
```

Para desarrollar un plugin, se monta su carpeta en `/var/www/html/Plugins/<Nombre>`
(es justo lo que hace la plantilla, seccion 1). Para abrir una shell o ejecutar como
root: `docker compose exec --user root facturascripts sh`.

### 0.4 En que se puede mejorar

- **Documentar el contrato dev**: el punto de montaje `/var/www/html/Plugins/<Nombre>` y
  el `volume` mutable son el contrato que usa la plantilla; conviene documentarlo como
  API estable para que otros entornos (no solo la plantilla) lo reutilicen.
- **Unificar el modelo de configuracion con el blueprint del Playground**: hoy el setup
  desatendido (`FS_*`) y el `blueprint.json` del Playground describen lo mismo (plugins,
  seed, empresa) con esquemas distintos. Un formato comun (o un conversor) evitaria
  mantener la demo en dos sitios.
- **`FS_PLUGINS` con nombres mapeados a ids**: la tabla de mapeo nombre->id de descarga
  esta hardcodeada; resolver el id desde el slug de la forja seria mas robusto.
- **Fallar el arranque si un plugin no instala** es seguro para CI pero duro para dev;
  un modo "best-effort" configurable ayudaria en desarrollo.
- **Tag `:main` vs version fija**: la plantilla usa `:main`; documentar/usar tags
  inmutables (`:2025.x`) daria builds mas reproducibles.

---

## 1. Plantilla de plugin: `facturascripts-plugin-template`

Plantilla base ("Use this template" en GitHub) para arrancar un plugin con todo
el andamiaje montado. Evita reescribir la configuracion de Docker, los tests y
los workflows en cada plugin nuevo.

### 1.1 Que incluye

```
facturascripts-plugin-template/
  facturascripts.ini            # name, description, version, min_version=2025, min_php=8.1
  Init.php                      # InitClass de ejemplo
  Controller/
    ExampleController.php        # controlador HTML simple
    ListExampleModel.php         # ListController de ejemplo
  Model/ExampleModel.php
  Table/example_table.xml
  XMLView/ListExampleModel.xml
  Translation/{es_ES,en_EN}.json
  Test/                         # PHPUnit: bootstrap, install-plugins, test de modelo
  docker-compose.yml            # MariaDB + erseco/alpine-facturascripts:main
  Makefile                      # up/down/lint/format/test/package/rebuild...
  phpcs.xml / .php-cs-fixer.php # estilo de codigo
  .github/workflows/ci.yml      # CI: entorno Docker + matriz PHP 8.1-8.5
  .github/workflows/release.yml # release por tag -> ZIP + GitHub Release + forja
```

### 1.2 Flujo de trabajo local (Makefile)

El `docker-compose.yml` levanta MariaDB y la imagen `erseco/alpine-facturascripts:main`,
montando el directorio del plugin en `/var/www/html/Plugins/PluginTemplate`. Instalacion
desatendida con `admin`/`admin` en `http://localhost:8080`.

```bash
make up               # arranca contenedores (interactivo); make upd para background
make enable-plugin    # activa el plugin en FacturaScripts
make rebuild          # recompila clases dinamicas (tras tocar Model/Controller)
make lint             # PHP CodeSniffer con phpcs.xml
make format           # PHP CS Fixer
make test             # PHPUnit dentro del contenedor
make package VERSION=1.2.3   # genera dist/PluginTemplate-1.2.3.zip
make down / make clean       # parar / parar + borrar volumenes
```

> Nota: la imagen usa `php84` como binario PHP. El `rebuild` llama a
> `http://localhost:8080/deploy?action=rebuild`.

### 1.3 Pasos para adoptar la plantilla

1. Crear repo desde la plantilla ("Use this template").
2. Renombrar `PluginTemplate` al nombre real del plugin en **todos** estos sitios:
   - `facturascripts.ini` -> `name`
   - namespaces PHP `FacturaScripts\Plugins\PluginTemplate\...`
   - `docker-compose.yml` -> ruta del volumen `.../Plugins/<Nombre>`
   - `Makefile` -> rutas `Plugins/PluginTemplate` en `lint`/`format`/`test`
   - `.github/workflows/release.yml` -> `--prefix`, nombre del ZIP y `plugin-slug`
   - `.github/workflows/ci.yml` -> rutas `Plugins/PluginTemplate`
3. Ajustar `version`, `min_version`, `min_php` y traducciones.
4. Revisar cabeceras de licencia/autoria.

### 1.4 Reglas importantes del `facturascripts.ini`

- `name` DEBE coincidir EXACTAMENTE con la carpeta del plugin y con el nombre
  registrado en la forja (sensible a mayusculas). Ver seccion 4.4.
- `min_version` >= 2025.
- La **version** debe ser un entero (`7`) o un decimal simple (`7.1`). La forja y
  el workflow de release **rechazan** `1.0.1` o `1.0-beta` (ver seccion 4).

### 1.5 En que se puede mejorar la plantilla

- **Target `make rename NAME=MiPlugin`**: el mayor punto de friccion es renombrar
  `PluginTemplate` a mano en ~6 ficheros. Un objetivo de Makefile que haga el
  `sed` en `facturascripts.ini`, namespaces, `docker-compose.yml`, `Makefile`,
  workflows y `release.yml:plugin-slug` ahorraria errores. (Hay un script de
  ejemplo en `templates/scripts/rename-plugin.sh`.)
- **Incluir un `pr-preview.yml` de serie**: la plantilla trae `ci.yml` y
  `release.yml`, pero NO el workflow de preview en el Playground. Anadirlo cierra
  el circulo "abrir PR -> probar en vivo". (Plantilla en `templates/.github/workflows/pr-preview.yml`.)
- **Incluir un `blueprint.json` en la raiz**: sirve a la vez como documentacion de
  como se prueba el plugin y como entrada directa para la action de preview.
- **`plugin-slug` derivado**: en `release.yml` el slug esta hardcodeado a
  `plugintemplate`; conviene derivarlo de `name` (en minusculas) o documentarlo como
  variable a cambiar para no publicar en el plugin equivocado.
- **Matriz PHP 8.5**: PHP 8.5 puede no estar disponible (todavia en desarrollo) en
  `setup-php`; conviene marcarlo `continue-on-error` o quitarlo hasta su release.
- **`make package` restaura version a `1.0` fija**: si tu version de desarrollo no es
  `1.0`, la deja inconsistente. Mejor restaurar el valor previo capturado.

---

## 2. Playground en el navegador: `facturascripts-playground`

Ejecuta una instancia completa de FacturaScripts **dentro del navegador** con
WebAssembly (`@php-wasm/web`) y SQLite, sin servidor. El core se monta readonly y
el estado mutable vive en IndexedDB. Instancia publica:
**https://erseco.github.io/facturascripts-playground/**

Sirve para: enseñar FacturaScripts en segundos, reproducir bugs en un entorno
limpio, y **probar un plugin o un PR sin instalar nada** mediante un `blueprint.json`.

### 2.1 Como se configura: `blueprint.json`

El blueprint es la descripcion portable del estado inicial. Se puede cargar de 3 formas:

- `?blueprint=/ruta/al/archivo.json`
- `?blueprint-data=...` con el JSON codificado en **base64url** (lo que genera la action de preview)
- importandolo desde el panel lateral de la shell

Estructura soportada hoy por el runtime:

| Propiedad | Uso |
| --- | --- |
| `meta` | `title`, `author`, `description` (descriptivo) |
| `debug.enabled` | muestra errores PHP en el navegador |
| `landingPage` | ruta de entrada (p.ej. `/AdminPlugins`) |
| `siteOptions` | `title`, `locale` (`es_ES`), `timezone` (`Europe/Madrid`) |
| `login` | `username`, `password` efectivos del admin |
| `plugins` | array de plugins: nombre presente en runtime, URL de ficha, URL ZIP, o URL de GitHub (rama/PR) |
| `seed` | datos demo idempotentes: `customers`, `suppliers`, `products` |
| `install` | datos base que crea el Wizard: empresa, impuestos, plan contable, series... |
| `settings` | ajustes de FacturaScripts `{ grupo: { clave: valor } }` (p.ej. email/SMTP) |

### 2.2 Probar plugins desde el blueprint

`plugins[]` acepta varias formas, todas resueltas a ZIP por el runtime:

```jsonc
{
  "plugins": [
    "MiPlugin",                                                  // ya presente en el runtime: solo se activa
    "https://facturascripts.com/plugins/commandpalette",         // ficha publica -> resuelve DownloadBuild
    "https://facturascripts.com/DownloadBuild/440/stable",       // build directo
    "https://github.com/erseco/mi-plugin/tree/main",             // rama de GitHub -> ZIP
    "https://github.com/erseco/mi-plugin/pull/123",              // cabeza de un PR -> ZIP
    "https://github.com/erseco/mi-plugin/archive/refs/heads/main.zip" // ZIP directo
  ]
}
```

Reglas: `.../tree/<branch>` descarga el ZIP de la rama; `.../pull/<n>` la cabeza del
PR; `.../archive/...` y `.../releases/download/...` se usan tal cual. Las descargas
remotas pasan por un proxy (`/__addon_proxy__` en local, `zip-proxy.erseco.workers.dev`
en estatico) y estan sujetas a `outboundHttp.allowedHosts`.

### 2.3 Sembrar datos demo (`seed`)

Upsert idempotente por clave natural (no duplica al recargar):

- `customers[]` -> clave obligatoria `codcliente`
- `suppliers[]` -> clave obligatoria `codproveedor`
- `products[]`  -> clave obligatoria `referencia`

Campos recomendados: clientes/proveedores `nombre`, `cifnif`, `email`, `telefono1`,
`direccion`, `ciudad`, `provincia`, `codpais`; productos `descripcion`, `precio`,
`stockfis`, `codfamilia`, `codimpuesto`.

### 2.4 Inicializacion (`install`) y ajustes (`settings`)

`install` reproduce el Wizard de FacturaScripts (empresa, impuestos, formas de pago,
series, diarios, retenciones, plan contable...). Idempotente. Campos principales:
`codpais` (`"ESP"`), `empresa`, `cifnif`, `ciudad`, `provincia`, `regimeniva`
(`"General"`), `defaultplan` (`true` importa el plan contable del pais).

`settings` precarga la tabla `settings` con la forma `{ grupo: { clave: valor } }`,
aplicado con `Tools::settingsSet(...)` + `Tools::settingsSave()`. Util para demos que
dependen de configuracion. Ejemplo email/SMTP (mismas claves que `/ConfigEmail`):

```json
{
  "settings": {
    "email": {
      "email": "demo@example.com", "host": "smtp.example.com", "port": "587",
      "user": "demo@example.com", "password": "demo", "mailer": "smtp", "enc": "tls"
    }
  }
}
```

### 2.5 Entorno local del propio playground

```bash
git clone https://github.com/erseco/facturascripts-playground.git
cd facturascripts-playground && make up   # http://localhost:8085 (admin/admin)
```

`make bundle` clona FacturaScripts (por defecto `erseco/facturascripts`, rama
`feature/add-sqlite-support`), ejecuta Composer y genera el bundle readonly. Se puede
apuntar a otro fork con `FS_REF=... FS_REF_BRANCH=... make bundle`.

### 2.6 En que se puede mejorar el playground

- **`seed` limitado al MVP**: solo `customers`/`suppliers`/`products`. Extenderlo a
  facturas, series, almacenes y stock avanzado permitiria demos mas realistas.
- **Resolver plugins por slug suelto**: hoy un nombre de `plugins[]` solo activa
  plugins ya presentes en el runtime; un slug de marketplace requiere URL directa.
  Resolver `slug -> DownloadBuild` automaticamente simplificaria los blueprints.
- **URLs `blueprint-data` muy largas**: el base64url de un blueprint grande genera
  URLs enormes. Un servicio de acortado/hosting de blueprints (devolviendo un id
  corto) mejoraria los enlaces en comentarios de PR.
- **Compatibilidad de navegador**: enfocado a Chromium; ampliar a Firefox/Safari.
- **Dependencia del proxy externo** (`zip-proxy.erseco.workers.dev`) para descargas en
  despliegue estatico: documentar como auto-alojarlo evitaria un punto unico de fallo.

---

## 3. Action: preview de PR en el Playground

`erseco/action-facturascripts-playground-pr-preview` publica (o actualiza) un
comentario "sticky" en cada Pull Request con un enlace **"Probar en el Playground"**.
Genera un `blueprint.json` a partir de los inputs, lo codifica en base64url y lo
adjunta como `?blueprint-data=...` a la URL del playground.

### 3.1 Como funciona

1. Construye un blueprint: `meta` + `plugins: [zip-url]` y, opcionalmente,
   `extra-plugins`, `seed`, `landingPage`, `debug`, `siteOptions`, `login`.
2. Aplica `blueprint-json` como capa de override final (control total).
3. Codifica en base64url y forma la URL `https://<playground>/?blueprint-data=...`.
4. Busca un marcador HTML oculto en los comentarios del PR (`<!-- facturascripts-playground-preview -->`)
   y crea o actualiza ese comentario (evita duplicados en cada push).

### 3.2 Inputs principales

| Input | Req. | Descripcion |
| --- | :---: | --- |
| `github-token` | ✅ | Token con permiso `pull-requests: write` |
| `zip-url` | ✅ | URL del ZIP del plugin/rama a cargar (p.ej. el archive de la rama del PR) |
| `mode` | ❌ | `comment` (sticky, por defecto) o `append-to-description` |
| `title` / `description` / `author` | ❌ | Metadatos del blueprint |
| `extra-plugins` | ❌ | Array JSON de plugins extra (p.ej. dependencias) |
| `seed-json` | ❌ | Objeto JSON con datos demo |
| `landing-page` | ❌ | Ruta inicial (p.ej. `/AdminPlugins`) |
| `site-locale` / `site-timezone` / `site-title` | ❌ | `siteOptions` |
| `login-username` / `login-password` | ❌ | Credenciales |
| `debug-enabled` | ❌ | `true`/`false` |
| `blueprint-json` | ❌ | Override final completo (merge al final) |
| `pr-number` | ❌ | Necesario si se dispara desde `workflow_run` |

Outputs: `preview-url`, `mode`, `comment-id`, `rendered-description`.

### 3.3 Uso minimo

```yaml
name: PR Preview
on:
  pull_request:
    types: [opened, synchronize, reopened]
permissions:
  contents: read
  pull-requests: write
jobs:
  preview:
    runs-on: ubuntu-latest
    steps:
      - uses: erseco/action-facturascripts-playground-pr-preview@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          zip-url: https://github.com/${{ github.repository }}/archive/refs/heads/${{ github.head_ref }}.zip
          title: Mi Plugin PR Preview
          extra-plugins: '["CommandPalette"]'
          site-locale: es_ES
          site-timezone: Europe/Madrid
```

Plantilla mas completa (con seed y blueprint avanzado) en
`templates/.github/workflows/pr-preview.yml`.

### 3.4 En que se puede mejorar

- **Auto-detectar `blueprint.json` del repo**: si el plugin ya tiene un
  `blueprint.json` en la raiz, la action podria leerlo en vez de exigir reespecificar
  `seed`, `plugins`, etc. en los inputs.
- **Forks y ramas privadas**: `zip-url` con el archive de `head_ref` puede no
  resolver en PRs desde forks; soportar el `merge ref` o subir un artifact del build
  lo haria mas robusto.
- **Adjuntar evidencia visual**: incluir un QR o una captura ayudaria a revisores.
- **Matriz de runtimes**: permitir generar varios enlaces (distintas versiones PHP/core).

---

## 4. Action: publicar en la forja

`erseco/action-facturascripts-publicar-forja` sube el ZIP del plugin como un nuevo
**build** en `facturascripts.com/forja` tras una release, con opcion de promover el
build a `stable`, `beta` o `0` (no disponible).

### 4.1 Como funciona (ingenieria inversa del flujo web)

1. Login `POST /MeLogin` con `email`+`passwd` (usa el **email**, no el nick).
2. Pide la pestaña admin del plugin y extrae un `multireqtoken` (CSRF) fresco.
3. Sube el ZIP como `multipart/form-data` con `action=add-build`.
4. Verifica que aparece una nueva fila de build y expone su id como output.
5. Opcional: re-abre el modal del build y hace `action=edit-build` para fijar el
   `status`, preservando `min_php`/`min_core`/`max_core`.

### 4.2 Inputs

| Input | Req. | Descripcion |
| --- | :---: | --- |
| `plugin-slug` | ✅ | Slug del plugin en la forja, minusculas |
| `zip-path` | ✅ | Ruta local al ZIP del paso anterior |
| `version` | ✅ | Entero (`7`) o decimal (`7.1`); se permite prefijo `v` |
| `forja-user` | ✅ | **Email** de facturascripts.com (secret) |
| `forja-password` | ✅ | Password de la forja (secret) |
| `status` | ❌ | `stable`, `beta` o `0` |
| `forja-url` | ❌ | Por defecto `https://facturascripts.com` |
| `dry-run` | ❌ | Login + CSRF sin subir |

Outputs: `build-id`, `build-version`, `build-url`, `build-status`.

### 4.3 Secrets necesarios

```bash
gh secret set FS_FORJA_USER --repo <owner>/<repo>      # email de la forja
gh secret set FS_FORJA_PASSWORD --repo <owner>/<repo>  # password
```

### 4.4 Requisitos del ZIP (3 nombres que deben coincidir)

Sensible a mayusculas. Si fallan, la forja devuelve un mensaje indicando el valor
esperado:

1. La carpeta raiz dentro del ZIP (p.ej. `QuickCreate/`).
2. El campo `name` en `facturascripts.ini` (`name = 'QuickCreate'`).
3. El nombre con el que el plugin esta registrado en la forja.

Normalmente coincide con el slug en minusculas, pero no siempre.

### 4.5 En que se puede mejorar

- **Fragilidad del scraping HTML**: depende del markup de facturascripts.com; un
  cambio de la forja puede romperla. Una API oficial de publicacion seria lo ideal;
  mientras tanto, conviene fijar selectores con cuidado y tests de regresion.
- **Idempotencia**: re-ejecutar con la misma `version` crea un build duplicado. Podria
  detectar el build existente y hacer update en vez de add.
- **Mapear semver -> version de forja**: como la forja solo admite enteros/decimales,
  un tag `1.2.3` no es valido. Un mapeo automatico (o un esquema de versionado claro)
  evitaria releases fallidas.
- **Verificacion post-subida**: re-descargar el build publicado y validar checksum.

---

## 5. Recetas combinadas

### 5.1 Probar un PR rapido (sin instalar nada)

Anadir `pr-preview.yml` (seccion 3.3) al repo del plugin. En cada PR aparece un
comentario con el enlace al Playground que instala la rama del PR. El revisor abre el
enlace y prueba el plugin en su navegador. Plantilla: `templates/.github/workflows/pr-preview.yml`.

### 5.2 Probar un plugin definiendo el `blueprint.json`

Crear un `blueprint.json` en la raiz del plugin con `plugins`, `install`, `seed` y
`settings` para dejar el entorno listo para la demo (empresa, datos, plugin activado).
Cargarlo en el Playground con `?blueprint=...` o via la action de preview. Plantilla:
`templates/blueprint.json`.

### 5.3 Automatizar el release

`release.yml` (de la plantilla) se dispara con un tag numerico (`1`, `1.2`), genera el
ZIP, crea la GitHub Release y publica en la forja con la action de la seccion 4.
Plantilla: `templates/.github/workflows/release.yml`. Recordar:

- el tag debe ser entero o decimal simple (no `1.2.3`);
- `name` en `facturascripts.ini` == carpeta del ZIP == nombre en la forja;
- definir los secrets `FS_FORJA_USER` y `FS_FORJA_PASSWORD`;
- ajustar `plugin-slug` y el nombre del ZIP al plugin real.

### 5.4 Ciclo completo recomendado

```
1. Crear repo desde facturascripts-plugin-template y renombrar el plugin.
2. Desarrollar en local:  make up -> make enable-plugin -> codigo -> make rebuild
3. Calidad:               make lint / make format / make test  (y CI en cada push)
4. PR:                    pr-preview.yml comenta el enlace de Playground con la rama
5. Merge + tag (1.2):     release.yml hace ZIP + GitHub Release + publica en la forja
```
