# 🐳 Guía Docker - TalleresApp

Documentación completa para desplegar TalleresApp usando Docker.

## 📋 Requisitos

- Docker 20.10+
- Docker Compose 2.0+
- Git

## 🚀 Inicio Rápido

### 1. Construir Imagen
```bash
docker build -t talleres-app:latest .
```

### 2. Ejecutar con Docker Compose
```bash
docker-compose up -d
```

La aplicación estará disponible en `http://localhost:3000`

### 3. Crear Admin
```bash
docker-compose exec web bundle exec rails console

user = User.create!(
  email: "admin@example.com",
  password: "Password123!",
  password_confirmation: "Password123!",
  role: :admin
)

estudiante = user.create_estudiante(
  nombre: "Admin",
  curso: "4°"
)
```

---

## 🛠️ Comandos Principales

### Docker Compose
```bash
# Levantar servicios
docker-compose up -d

# Ver logs
docker-compose logs -f web

# Bajar servicios
docker-compose down

# Reiniciar
docker-compose restart

# Ejecutar comando en contenedor
docker-compose exec web bash
```

### Migraciones y Seeds
```bash
# Ejecutar migraciones
docker-compose exec web bundle exec rails db:migrate

# Cargar datos de ejemplo
docker-compose exec web bundle exec rails db:seed

# Reset completo
docker-compose exec web bundle exec rails db:reset
```

### Testing
```bash
# Ejecutar tests
docker-compose exec web bundle exec rspec

# Tests específicos
docker-compose exec web bundle exec rspec spec/models/taller_spec.rb

# Con coverage
docker-compose exec web bundle exec rspec --format documentation
```

### Rails Console
```bash
docker-compose exec web bundle exec rails console
```

---

## 📦 Estructura Docker

### Dockerfile (Multi-stage)
Optimiza el tamaño de la imagen usando multi-stage builds:

1. **Stage 1 (builder)**: Compila gemas y assets
2. **Stage 2 (final)**: Solo incluye dependencias de runtime

**Beneficios**:
- Imagen final ~500MB (vs 2GB sin optimizar)
- Seguridad: Usuario no-root
- Health checks integrados
- Rápido inicio de contenedor

### docker-compose.yml
Define servicios necesarios:

```yaml
web:
  build: .
  ports:
    - "3000:3000"
  environment:
    RAILS_ENV: production
    DATABASE_URL: sqlite3://storage/production.sqlite3
  volumes:
    - ./storage:/app/storage
    - ./log:/app/log
```

---

## 🔐 Seguridad

### En Producción

#### 1. Master Key
```bash
# El Dockerfile usa variable de entorno
-e RAILS_MASTER_KEY=$(cat config/master.key)

# O en docker-compose
environment:
  RAILS_MASTER_KEY: ${RAILS_MASTER_KEY}
```

#### 2. Usuario No-Root
```dockerfile
USER 1000:1000  # Ejecuta como usuario rails, no root
```

#### 3. Health Checks
```bash
# Docker verifica salud cada 30s
HEALTHCHECK --interval=30s ...
```

#### 4. Variables Secretas
```bash
# Nunca commitear secrets
# Usar .env.example para documentar variables
```

---

## 🌍 Variables de Entorno

### Desarrollo
```env
RAILS_ENV=development
RAILS_LOG_TO_STDOUT=true
```

### Producción
```env
RAILS_ENV=production
RAILS_LOG_TO_STDOUT=true
RAILS_SERVE_STATIC_FILES=true
RAILS_MASTER_KEY=<key from config/master.key>
DATABASE_URL=sqlite3:///app/storage/production.sqlite3
```

### Custom Database (PostgreSQL)
```env
DATABASE_URL=postgres://user:password@db:5432/talleres_app_prod
```

---

## 🔧 Customización

### Cambiar Puerto
```bash
# docker-compose.yml
ports:
  - "8080:3000"  # Mapea 8080 local → 3000 contenedor

# O en línea de comandos
docker run -p 8080:3000 talleres-app:latest
```

### Agregar Variables de Entorno
```yaml
# docker-compose.yml
environment:
  RAILS_ENV: production
  CUSTOM_VAR: value
  ANOTHER_VAR: another_value
```

### Montar Volúmenes
```bash
docker run -v /ruta/local:/app/storage talleres-app:latest
```

### Usar Database Diferente
```yaml
# docker-compose.yml
environment:
  DATABASE_URL: postgres://user:pass@postgres:5432/db_name

# En production, reemplazar DATABASE_URL antes de deployar
```

---

## 📊 Monitoreo

### Ver Logs
```bash
# Últimas líneas
docker-compose logs web

# Seguimiento en vivo
docker-compose logs -f web

# Específico período
docker-compose logs web --tail=100 -f
```

### Health Check
```bash
# Verificar estado
docker-compose ps

# Ver estado detallado
docker inspect --format='{{json .State.Health}}' talleres-app
```

### Estadísticas
```bash
# CPU, memoria, red, I/O
docker stats

# O por contenedor
docker stats talleres-app
```

---

## 🚀 Deployment

### Docker Hub
```bash
# Login
docker login

# Tag imagen
docker tag talleres-app:latest username/talleres-app:latest

# Push
docker push username/talleres-app:latest

# En servidor remoto
docker pull username/talleres-app:latest
docker run -d -p 3000:3000 username/talleres-app:latest
```

### AWS ECR
```bash
# Create repository
aws ecr create-repository --repository-name talleres-app

# Login
aws ecr get-login-password | docker login --username AWS ...

# Tag y push
docker tag talleres-app:latest 123456789.dkr.ecr.us-east-1.amazonaws.com/talleres-app:latest
docker push 123456789.dkr.ecr.us-east-1.amazonaws.com/talleres-app:latest
```

### DigitalOcean App Platform
```bash
# Usar docker-compose.yml
doctl apps create --spec docker-compose.yml
```

---

## 🧪 Testing en Docker

### Unit Tests
```bash
docker-compose exec web bundle exec rspec spec/models/

docker-compose exec web bundle exec rspec spec/models/user_spec.rb
```

### Controller Tests
```bash
docker-compose exec web bundle exec rspec spec/controllers/
```

### Todos los Tests
```bash
docker-compose exec web bundle exec rspec

# Con formato documentación
docker-compose exec web bundle exec rspec --format documentation
```

---

## 🐛 Troubleshooting

### Container no inicia
```bash
# Ver logs
docker-compose logs web

# Verificar build
docker build --no-cache -t talleres-app:latest .

# Ejecutar bash para debuggear
docker-compose run --rm web bash
```

### Base de datos bloqueada
```bash
# SQLite se bloquea si múltiples procesos acceden
# Solución: Usar PostgreSQL en producción

# Para desarrollo con SQLite:
docker-compose exec web rm storage/production.sqlite3
docker-compose exec web bundle exec rails db:create db:migrate
```

### Cambios no se reflejan
```bash
# Reconstruir imagen (ignorar cache)
docker-compose build --no-cache

# Levantar nuevamente
docker-compose up -d
```

### Permisos en volúmenes
```bash
# En Linux, puede haber problemas de permisos
# Solución: Usar usuario rails en Dockerfile
USER 1000:1000
```

### Puerto ya en uso
```bash
# Cambiar puerto en docker-compose.yml
ports:
  - "3001:3000"  # Usar 3001 en lugar de 3000

# O encontrar qué está usando puerto 3000
lsof -i :3000  # Linux/Mac
netstat -ano | findstr :3000  # Windows
```

---

## ⚡ Optimizaciones

### Reduce Tamaño Imagen
- ✅ Multi-stage Dockerfile (implementado)
- ✅ Alpine Linux base (considerado: más complicado con Ruby)
- ✅ .dockerignore (implementado)

### Faster Builds
```bash
# Usar BuildKit
DOCKER_BUILDKIT=1 docker build -t talleres-app:latest .

# Cache layers bien
# 1. Copiar Gemfile
# 2. bundle install
# 3. Copiar código
```

### Faster Startup
```bash
# Precompile bootsnap
RUN bundle exec bootsnap precompile -j 1 app/ lib/

# Precompile assets
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
```

---

## 📚 Recursos Adicionales

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Rails Docker Guide](https://guides.rubyonrails.org/docker.html)
- [Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)

---

**Última actualización**: Diciembre 8, 2025
