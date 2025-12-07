# TalleresApp — Proyecto Educativo con Rails 8 + Tailwind + Devise

TalleresApp es una aplicación educativa para gestionar talleres y estudiantes. Está pensada para enseñar el patrón MVC en Rails, autenticación con Devise, estilos con TailwindCSS y creación de APIs.

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
4. Arranca el entorno de desarrollo (Rails + Tailwind en watch):
	 ```powershell
	 bin\dev
	 ```

## Estructura y Rutas
- Rutas RESTful principales:
	- `resources :talleres`
	- `resources :estudiantes`
- Autenticación:
	- `devise_for :users`
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
- El layout base (`app/views/layouts/application.html.erb`) incluye un menú responsive con Stimulus y Tailwind, y un footer fijado al final.

## Problemas Comunes
- Si Tailwind no aplica estilos, verifica:
	- `npm run build:css` genera `app/assets/builds/application.css`
	- `config/initializers/assets.rb` incluye `app/assets/builds`
	- Corre `bin\dev` para ver Rails y CSS en watch.

