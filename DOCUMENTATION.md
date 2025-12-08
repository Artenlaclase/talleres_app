# 🎓 Talleres App - Documentación Completa

Una aplicación Rails 8.1 para gestionar talleres educativos, inscripciones de estudiantes, calificaciones y aprobaciones con autenticación mediante Devise.

## 📋 Características Principales

### ✅ Sistema de Talleres
- Crear, editar y eliminar talleres
- Gestionar cupos disponibles
- Definir número de evaluaciones por taller
- Visualizar lista de estudiantes inscritos

### 👥 Gestión de Estudiantes
- Registro de estudiantes con asociación a usuarios
- Máximo 3 talleres por período académico
- Visualizar talleres activos y calificaciones
- Inscripciones a múltiples talleres

### 📝 Sistema de Inscripciones
- **Inscripción por Estudiante**: Solicitar inscripción (estado: pendiente)
- **Inscripción por Admin**: Agregar estudiantes directamente (estado: aprobada)
- Dashboard de solicitudes pendientes
- Aprobación/Rechazo de inscripciones
- Desinscripción de talleres

### 📊 Calificaciones
- Sistema de calificaciones con escala 1.0-7.0
- Múltiples evaluaciones por taller
- Aprobación automática (≥5.5)
- Dashboard con filtros y estadísticas

### 🔐 Autenticación y Autorización
- Autenticación con Devise
- Roles: `usuario` (estudiante) y `admin` (profesor/administrador)
- Bloqueo de cuentas
- Scopes para permisos

### 🧪 Testing
- Infraestructura RSpec completa
- 46+ tests pasando
- Specs para modelos y controladores
- FactoryBot para fixtures

---

## 🚀 Instalación

### Requisitos Previos
- Ruby 3.4+
- Node.js 18+
- SQLite3
- Bundler

### Pasos de Instalación

#### 1. Clonar el Repositorio
```bash
git clone https://github.com/Artenlaclase/talleres_app.git
cd talleres_app
```

#### 2. Instalar Dependencias
```bash
bundle install
npm install
```

#### 3. Configurar Base de Datos
```bash
# Crear y migrar base de datos
bundle exec rails db:create
bundle exec rails db:migrate

# Cargar datos de ejemplo (opcional)
bundle exec rails db:seed
```

#### 4. Compilar Assets
```bash
npm run build:css
bundle exec rails assets:precompile
```

#### 5. Iniciar Servidor
```bash
./bin/dev
```

La aplicación estará disponible en `http://localhost:3000`

---

## 📱 Uso Inicial

### Crear Cuenta Admin
```bash
bundle exec rails console

user = User.create!(
  email: "admin@example.com",
  password: "Password123!",
  password_confirmation: "Password123!",
  role: :admin
)

estudiante = user.create_estudiante(
  nombre: "Admin User",
  curso: "4°"
)

puts "Admin creado: #{user.email}"
```

### Crear Cuenta Estudiante
```bash
user = User.create!(
  email: "estudiante@example.com",
  password: "Password123!",
  password_confirmation: "Password123!",
  role: :usuario
)

estudiante = user.create_estudiante(
  nombre: "Juan García",
  curso: "3°"
)

puts "Estudiante creado: #{user.email}"
```

---

## 🗄️ Estructura de Base de Datos

### Tablas Principales

#### `users`
```
- id (primary key)
- email (unique, indexed)
- encrypted_password
- role (enum: usuario/admin)
- locked_at (timestamp)
- created_at, updated_at
```

#### `estudiantes`
```
- id (primary key)
- nombre (string)
- curso (string)
- user_id (foreign key)
- taller_id (foreign key)
- max_talleres_por_periodo (default: 3)
- created_at, updated_at
```

#### `talleres`
```
- id (primary key)
- nombre (string)
- descripcion (text)
- fecha (date)
- cupos (integer)
- numero_evaluaciones (default: 5)
- created_at, updated_at
```

#### `inscripciones`
```
- id (primary key)
- estudiante_id (foreign key)
- taller_id (foreign key)
- estado (enum: pendiente/aprobada/rechazada)
- unique constraint: (estudiante_id, taller_id)
```

#### `calificaciones`
```
- id (primary key)
- estudiante_id (foreign key)
- taller_id (foreign key)
- nombre_evaluacion (string)
- nota (decimal: 1.0-7.0)
- created_at, updated_at
```

---

## 🔄 Flujos de Trabajo

### Flujo de Inscripción

#### Ruta 1: Estudiante Solicita Inscripción
```
Estudiante clicks "Solicitar Inscripción"
    ↓
POST /estudiantes/:id/request_inscription?taller_id=X
    ↓
Validar: max 3 talleres, cupos > 0
    ↓
Crear Inscripcion con estado="pendiente"
    ↓
Mostrar: "⏳ Tu inscripción está en espera"
    ↓
Admin ve solicitud en /talleres#pending
    ↓
Admin clicks "Aprobar" → PATCH /inscripciones/:id/approve
    ↓
estado → "aprobada"
    ↓
Estudiante ahora está inscrito
```

#### Ruta 2: Admin Agrega Directamente
```
Admin navega a /talleres/:id/inscripciones/new
    ↓
Selecciona estudiante de lista disponible
    ↓
POST /talleres/:id/inscripciones
    ↓
Validar: max 3 talleres, cupos > 0
    ↓
Crear Inscripcion con estado="aprobada" inmediatamente
    ↓
Mostrar: "✓ Estudiante inscrito correctamente"
```

### Validaciones de Cupo
- **Máximo talleres**: 3 por período
- **Verificación cupo**: `cupos_restantes > 0`
  - Solo cuenta inscripciones con `estado = 'aprobada'`
  - Fórmula: `cupos - COUNT(inscripciones where estado='aprobada')`
- **Mensaje de error**: "❌ El taller está lleno. No hay cupos disponibles."

---

## 🧪 Testing

### Estructura de Tests
```
spec/
├── models/
│   ├── user_spec.rb (8 tests)
│   ├── taller_spec.rb (15 tests)
│   └── inscripcion_spec.rb (9 tests)
├── controllers/
│   ├── estudiantes_controller_spec.rb (6 tests)
│   └── inscripciones_controller_spec.rb (8 tests)
├── factories/
│   ├── users.rb
│   ├── estudiantes.rb
│   ├── talleres.rb
│   ├── inscripciones.rb
│   └── calificaciones.rb
└── support/
    └── devise.rb
```

### Ejecutar Tests
```bash
# Todos los tests
bundle exec rspec

# Tests específicos
bundle exec rspec spec/models/taller_spec.rb
bundle exec rspec spec/controllers/estudiantes_controller_spec.rb

# Con formato documentación
bundle exec rspec --format documentation

# Solo modelos
bundle exec rspec spec/models/

# Solo controladores
bundle exec rspec spec/controllers/
```

### Estadísticas
- ✅ **46 ejemplos** pasando
- 32 specs de modelos
- 14 specs de controladores
- 0 fallos

---

## 🐳 Docker

### Construcción

#### Construir Imagen
```bash
docker build -t talleres-app:latest .
```

#### Ejecutar Contenedor (Desarrollo)
```bash
docker run -it -p 3000:3000 \
  -v $(pwd):/app \
  -e RAILS_ENV=development \
  talleres-app:latest
```

#### Ejecutar Contenedor (Producción)
```bash
docker run -d -p 3000:3000 \
  -e RAILS_ENV=production \
  -e RAILS_MASTER_KEY=$(cat config/master.key) \
  --name talleres-prod \
  talleres-app:latest
```

### Docker Compose
```bash
# Levantar servicios
docker-compose up -d

# Ver logs
docker-compose logs -f web

# Bajar servicios
docker-compose down
```

### Variables de Entorno
```env
RAILS_ENV=production
RAILS_LOG_TO_STDOUT=true
RAILS_MASTER_KEY=<key>
DATABASE_URL=sqlite3:///app/storage/production.sqlite3
```

---

## 🛠️ Comandos Útiles

### PowerShell (scripts/talleres-functions.ps1)
```powershell
# Cargar funciones
. scripts/talleres-functions.ps1

# Backup datos
Export-TalleresData -Path backup

# Restaurar datos
Import-TalleresData -Path backup

# Reset BD
Reset-TalleresDatabase

# Verificar datos
Test-TalleresData

# Seed datos de muestra
Initialize-TalleresData

# Consola Rails
Show-TalleresConsole
```

### Rake Tasks
```bash
# Exportar datos a JSON
bundle exec rake export:talleres[path/to/file.json]
bundle exec rake export:estudiantes[path/to/file.json]

# Importar datos desde JSON
bundle exec rake import:talleres[path/to/file.json]
bundle exec rake import:estudiantes[path/to/file.json]
```

### Rails Console
```bash
bundle exec rails console

# Crear usuario
user = User.create!(email: 'test@example.com', password: 'Pass123!', role: :usuario)

# Listar talleres con cupo
Taller.con_cupo.proximos

# Contar inscripciones pendientes
Inscripcion.pendientes.count

# Estadísticas de calificaciones
Calificacion.aprobadas.count  # Aprobados (≥5.5)
Calificacion.reprobadas.count # Reprobados (<5.5)
```

---

## 📚 Stack Tecnológico

### Backend
- **Rails** 8.1.1
- **Ruby** 3.4+
- **SQLite3** - Base de datos
- **Devise** - Autenticación
- **Puma** - Web server

### Frontend
- **Tailwind CSS** 4.1
- **Stimulus JS** - Interactividad
- **Turbo Rails** - SPA-like experience

### Testing
- **RSpec** 7.1 - Framework de testing
- **FactoryBot** 6.5 - Test fixtures
- **Faker** 3.5 - Generador de datos
- **Shoulda Matchers** 5.3 - Validación matchers
- **Rails Controller Testing** 1.0 - Helper de controladores

### DevOps
- **Docker** & **Docker Compose**
- **Propshaft** - Asset pipeline
- **Importmap Rails** - JS bundling

---

## 📋 APIs y Endpoints

### Autenticación (Devise)
- `POST /users/sign_up` - Registro
- `POST /users/sign_in` - Login
- `DELETE /users/sign_out` - Logout
- `POST /users/password` - Reset contraseña

### Talleres
| Método | Ruta | Descripción | Auth |
|--------|------|-------------|------|
| GET | `/talleres` | Listar con solicitudes pendientes | Usuario |
| GET | `/talleres/:id` | Detalle con estudiantes | Usuario |
| POST | `/talleres` | Crear | Admin |
| PATCH | `/talleres/:id` | Actualizar | Admin |
| DELETE | `/talleres/:id` | Eliminar | Admin |

### Estudiantes
| Método | Ruta | Descripción | Auth |
|--------|------|-------------|------|
| GET | `/estudiantes/:id` | Perfil con talleres y calificaciones | Usuario |
| POST | `/estudiantes/:id/request_inscription` | Solicitar inscripción | Usuario |

### Inscripciones
| Método | Ruta | Descripción | Auth |
|--------|------|-------------|------|
| POST | `/talleres/:taller_id/inscripciones` | Crear | Admin |
| PATCH | `/inscripciones/:id/approve` | Aprobar | Admin |
| PATCH | `/inscripciones/:id/reject` | Rechazar | Admin |
| DELETE | `/inscripciones/:id` | Eliminar/Desinscribir | Admin |

### Calificaciones
| Método | Ruta | Descripción | Auth |
|--------|------|-------------|------|
| GET | `/talleres/:taller_id/calificaciones` | Listar | Admin |
| POST | `/talleres/:taller_id/calificaciones` | Crear | Admin |
| PATCH | `/calificaciones/:id` | Actualizar | Admin |
| DELETE | `/calificaciones/:id` | Eliminar | Admin |

---

## 🔒 Seguridad

- ✅ Protección CSRF en todos los formularios
- ✅ Autenticación Devise con validación de email
- ✅ Scopes de autorización (admin-only actions)
- ✅ Bloqueo de cuentas (`locked_at` timestamp)
- ✅ Validación de modelos en múltiples capas
- ✅ Unique constraints en BD
- ✅ Encriptación de contraseñas
- ✅ Validación de permisos antes de cada acción

---

## 📊 Modelos y Asociaciones

### Diagrama de Relaciones
```
User (1)
  ├── has_one Estudiante
  └── has_many Calificaciones (through Estudiante)

Estudiante (*)
  ├── belongs_to User
  ├── belongs_to Taller (primary)
  ├── has_many Inscripciones
  ├── has_many Talleres (through Inscripciones)
  └── has_many Calificaciones

Taller (1)
  ├── has_many Estudiantes
  ├── has_many Inscripciones
  └── has_many Calificaciones

Inscripcion (*)
  ├── belongs_to Estudiante
  ├── belongs_to Taller
  └── enum estado: [:pendiente, :aprobada, :rechazada]

Calificacion (*)
  ├── belongs_to Estudiante
  └── belongs_to Taller
```

### Validaciones por Modelo

**User**
- Email: presencia, unicidad, formato válido
- Contraseña: mínimo 8 caracteres (Devise)
- Role: enum [:usuario, :admin]

**Estudiante**
- Nombre: presencia, máximo 100 caracteres
- Curso: presencia
- max_talleres_por_periodo: default 3

**Taller**
- Nombre: presencia, máximo 100 caracteres
- Fecha: presencia, fecha válida
- Cupos: presencia, mayor que 0
- numero_evaluaciones: mayor que 0

**Inscripcion**
- Unicidad: estudiante_id + taller_id
- estado: presencia, enum válido

**Calificacion**
- Nota: presencia, entre 1.0 y 7.0
- Estudiante: presencia
- Taller: presencia

---

## 🐛 Troubleshooting

### Error: "Migrations are pending"
```bash
bundle exec rails db:migrate
```

### Error: "Can't find master key"
```bash
# En producción, verificar RAILS_MASTER_KEY env var
# En desarrollo, regenerar:
bundle exec rails credentials:edit
```

### Tests fallando
```bash
bundle exec rails db:migrate RAILS_ENV=test
bundle exec rspec --format documentation
```

### Puerto 3000 ocupado
```bash
# Usar puerto diferente
bundle exec rails s -p 3001

# O en Docker
docker run -p 3001:3000 ...
```

### Assets no compilan
```bash
# Limpiar y recompilar
bundle exec rails assets:clobber
npm run build:css
bundle exec rails assets:precompile
```

### SQLite bloqueado
```bash
# Eliminar BD y recrear
rm storage/development.sqlite3
bundle exec rails db:create db:migrate db:seed
```

---

## 🔄 Ciclo de Desarrollo

### Crear Nueva Migración
```bash
bundle exec rails generate migration MigrationName
# Editar db/migrate/timestamp_migration_name.rb
bundle exec rails db:migrate
```

### Crear Nuevo Modelo
```bash
bundle exec rails generate model ModelName field:type field:type
# Editar modelo y migración
bundle exec rails db:migrate
```

### Crear Nuevo Controlador
```bash
bundle exec rails generate controller ControllerName action1 action2
# Editar controlador y vistas
```

### Crear Tests
```bash
# Modelo
bundle exec rails generate rspec:model ModelName

# Controlador
bundle exec rails generate rspec:controller ControllerName

# Factory
bundle exec rails generate factory_bot:model ModelName
```

---

## 📝 Convenciones del Proyecto

### Nomenclatura
- Modelos: Singular, PascalCase (User, Estudiante, Taller)
- Controladores: Plural, PascalCase (UsersController, EstudiantesController)
- Vistas: Plural, snake_case (estudiantes/show.html.erb)
- Rutas: Plural, snake_case (resources :estudiantes)

### Estructura de Carpetas
```
app/
├── controllers/
│   ├── application_controller.rb
│   ├── talleres_controller.rb
│   ├── estudiantes_controller.rb
│   ├── inscripciones_controller.rb
│   └── calificaciones_controller.rb
├── models/
│   ├── user.rb
│   ├── estudiante.rb
│   ├── taller.rb
│   ├── inscripcion.rb
│   └── calificacion.rb
└── views/
    ├── layouts/application.html.erb
    ├── talleres/
    ├── estudiantes/
    ├── inscripciones/
    └── calificaciones/
```

---

## 📄 Licencia

MIT License - Proyecto educativo

## 👨‍💼 Autor

Artenlaclase - Plataforma educativa de talleres

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📞 Soporte

Para reportar problemas o sugerencias, abre un issue en el repositorio.

---

**Última actualización:** Diciembre 8, 2025 | **Versión:** 1.0.0 | **Rails:** 8.1.1
