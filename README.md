# TalleresApp — Proyecto Educativo con Rails 8 + Tailwind + Devise + Action Cable

TalleresApp es una aplicación educativa para gestionar talleres y estudiantes. Está pensada para enseñar el patrón MVC en Rails, autenticación con Devise, estilos con TailwindCSS, creación de APIs y **notificaciones en tiempo real con Action Cable**.

## ✨ Nuevas Características (v1.1)

### 🔔 Sistema de Notificaciones en Tiempo Real
- Notificaciones automáticas cuando se crean inscripciones
- Updates en vivo via Action Cable (WebSocket)
- Badge con contador en navbar
- Centro de notificaciones con historial completo

### 📊 Dashboard de Estadísticas
- Métricas en tiempo real (total talleres, estudiantes, inscripciones)
- Panel admin con notificaciones recientes
- Actividad reciente (talleres y estudiantes)
- Acciones rápidas para admins

👉 **Ver documentación completa**: [IMPLEMENTACION_COMPLETADA.md](IMPLEMENTACION_COMPLETADA.md)

## Prerrequisitos
- Ruby: `>= 3.2`
- Rails: `~> 8.1.1`
- Base de datos: SQLite3 (desarrollo)
- Node.js y npm (para Tailwind CLI)

## Instalación
1. Instala gemas:
	 ```powershell
	 bundle install
	 ```
2. Configura la base de datos y ejecuta migraciones:
	 ```powershell
	 rails db:setup
	 # o
	 rails db:create; rails db:migrate; rails db:seed
	 ```
3. Instala dependencias de JS y compila CSS:
	 ```powershell
	 npm install
	 npm run build:css
	 ```
4. Arranca el entorno de desarrollo (Rails + Tailwind + WebSocket):
	 ```powershell
	 bin\dev
	 ```

## Estructura y Rutas
- Rutas RESTful principales:
	- `resources :talleres`
	- `resources :estudiantes`
- Autenticación:
	- `devise_for :users`
- Notificaciones:
	- `resources :notifications` (nuevo)
	- WebSocket: `mount ActionCable.server => '/cable'` (nuevo)
- API JSON:
	- `GET /api/v1/talleres`
	- `GET /api/v1/estudiantes`

## Flujo de Aprendizaje (Guía MVC)
- Crear un Taller:
	- Controlador: `app/controllers/talleres_controller.rb` → método `create`
	- Modelo: `app/models/taller.rb` (validaciones, relaciones)
	- Vista: `app/views/talleres/_form.html.erb` y páginas `new`/`edit`
- Listar Talleres:
	- Controlador: método `index`
	- Vista: `app/views/talleres/index.html.erb`
- Relación Estudiante ↔ Taller:
	- Modelo: `app/models/estudiante.rb` con `belongs_to :taller`
	- Migración: agrega `taller_id` en `db/migrate/*_add_taller_to_estudiantes.rb`
- Autenticación y Roles:
	- Devise: `User` en `app/models/user.rb`
	- Restricción de acciones: `before_action :authenticate_user!` y método `require_admin!` en `ApplicationController`
- **Notificaciones en Tiempo Real (NUEVO)**:
	- Modelo: `app/models/notification.rb` (nueva)
	- Channel: `app/channels/notifications_channel.rb` (nueva)
	- Controller: `app/controllers/notifications_controller.rb` (nuevo)
	- Callbacks en Inscripcion: `after_create :notify_admins_on_inscription`
	- Stimulus JS: `app/javascript/controllers/notifications_controller.js`

## Estilos con TailwindCSS
- Entrada CSS: `app/assets/stylesheets/application.tailwind.css` (usa `@import "tailwindcss"`)
- Salida compilada: `app/assets/builds/application.css`
- Configuración: `tailwind.config.js` (incluye paths de vistas y JS)

## Ejecutar Pruebas
- System tests y unit tests (si aplica) en `test/`
	```powershell
	rails test
	```

## Notas de Proyecto
- El repositorio y carpeta raíz se llaman `talleres_app` para reflejar el nombre de la aplicación.
- El layout base (`app/views/layouts/application.html.erb`) incluye un menú responsive con Stimulus y Tailwind, un footer fijado al final, y **badge de notificaciones en navbar**.
- WebSocket funciona automáticamente con `bin/dev` (⚠️ NO usar `rails s`)

## Problemas Comunes
- Si Tailwind no aplica estilos, verifica:
	- `npm run build:css` genera `app/assets/builds/application.css`
	- `config/initializers/assets.rb` incluye `app/assets/builds`
	- Corre `bin\dev` para ver Rails y CSS en watch.
- Si las notificaciones no llegan en tiempo real:
	- ⚠️ Debes usar `bin/dev` (no `rails s`)
	- Verifica que Action Cable esté corriendo
	- Revisa la consola del navegador (F12)

## 📚 Documentación Adicional

| Documento | Contenido |
|-----------|----------|
| [IMPLEMENTACION_COMPLETADA.md](IMPLEMENTACION_COMPLETADA.md) | Resumen completo de mejoras |
| [NOTIFICATIONS_SYSTEM.md](NOTIFICATIONS_SYSTEM.md) | Documentación técnica del sistema |
| [GUIA_NOTIFICACIONES_RAPIDA.md](GUIA_NOTIFICACIONES_RAPIDA.md) | Guía rápida para usuarios |
| [CODE_EXAMPLES.md](CODE_EXAMPLES.md) | Ejemplos de código para developers |

## Guía con Capturas
Coloca las imágenes en `docs/images/` y referencia con Markdown.

- Inicio y servidor:
	- `![Servidor en ejecución](docs/images/server-running.png)`
	- `![Home en escritorio](docs/images/home-desktop.png)`
- Navbar responsive con badge:
	- `![Navbar en móvil con notificaciones](docs/images/navbar-mobile.png)`
- Dashboard de estadísticas:
	- `![Dashboard home admin](docs/images/dashboard-admin.png)`
- Notificaciones:
	- `![Centro de notificaciones](docs/images/notifications-center.png)`
- CRUD Talleres:
	- `![Listado de talleres](docs/images/talleres-index.png)`
	- `![Formulario Nuevo Taller](docs/images/talleres-form-new.png)`
	- `![Detalle de taller](docs/images/taller-show.png)`
- Estudiantes:
	- `![Formulario Estudiante con selector de Taller](docs/images/estudiantes-form.png)`
- Autenticación (Devise):
	- `![Login](docs/images/devise-login.png)`
	- `![Registro](docs/images/devise-register.png)`
	- `![Reset Password](docs/images/devise-reset.png)`
- Footer:
	- `![Footer fijo al final](docs/images/footer-sticky.png)`
- API:
	- `![API talleres JSON](docs/images/api-talleres-json.png)`

### Checklist de Capturas
- [ ] Servidor corriendo y home
- [ ] Navbar en móvil (hamburguesa y menú)
- [ ] Badge de notificaciones en navbar
- [ ] Dashboard con estadísticas
- [ ] Centro de notificaciones
- [ ] Listado de talleres
- [ ] Formulario nuevo taller
- [ ] Detalle de taller
- [ ] Formulario estudiante
- [ ] Pantallas de Devise (login/registro/reset)
- [ ] Footer sticky
- [ ] Respuesta JSON de API
