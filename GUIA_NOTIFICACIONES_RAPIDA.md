# 🚀 GUÍA RÁPIDA - Sistema de Notificaciones

## ¿Qué se agregó?

### 1️⃣ Modelo `Notification`
- Tabla en BD para guardar todas las notificaciones
- Relación con `User` (usuario propietario)
- Relación con `Inscripcion` (opcional)

### 2️⃣ Action Cable WebSocket
- Notificaciones en tiempo real
- No necesita refrescar la página
- Automático cuando se crean/aprueban inscripciones

### 3️⃣ Dashboard Mejorado (Home)
```
📊 Estadísticas:
  • Total Talleres: XX
  • Total Estudiantes: XX
  • Inscripciones Pendientes: XX
  • Inscripciones Aprobadas: XX

👤 Panel Admin (solo admins):
  • 🔔 Notificaciones sin leer
  • 📋 Acciones rápidas
  • 📈 Actividad reciente
```

### 4️⃣ Badge en Navbar
- Icono de campana 🔔
- Número rojo mostrando notificaciones sin leer
- Click abre `/notifications`

### 5️⃣ Centro de Notificaciones (`/notifications`)
- Lista completa de tu historial
- Ver, marcar como leída, eliminar
- Filtrar por tipo

## 📝 Cómo Funciona

```
Usuario A se inscribe en un Taller
    ↓
Automático: Se crea Notification para todos los admins
    ↓
Admin ve badge con número rojo
    ↓
Admin hace clic en el badge
    ↓
Abre página de notificaciones
    ↓
Admin aprueba la inscripción
    ↓
Automático: Se crea Notification para el Usuario A
    ↓
Usuario A ve notificación en tiempo real (sin refrescar)
```

## 🔧 Archivos Creados/Modificados

### ✨ Nuevos Archivos
```
app/models/notification.rb
app/controllers/notifications_controller.rb
app/channels/notifications_channel.rb
app/channels/application_cable/channel.rb
app/channels/application_cable/connection.rb
app/views/notifications/index.html.erb
app/views/notifications/_notification.html.erb
app/javascript/controllers/notifications_controller.js
db/migrate/20250101000001_create_notifications.rb
NOTIFICATIONS_SYSTEM.md (documentación completa)
```

### 📝 Modificados
```
app/models/user.rb                    (+ has_many :notifications)
app/models/inscripcion.rb             (+ callbacks + notificaciones)
app/controllers/pages_controller.rb    (+ dashboard stats)
app/views/pages/home.html.erb          (+ dashboard visual)
app/views/layouts/application.html.erb (+ badge navbar)
config/routes.rb                       (+ rutas + Action Cable)
```

## 🎯 Casos de Uso

### Para Admins
✅ Reciben notificación automática cuando hay inscripción pendiente  
✅ Ven listado en home y en `/notifications`  
✅ Pueden marcar como leída  
✅ Ven badge con número sin leer  

### Para Estudiantes
✅ Se notifican cuando su inscripción es aprobada/rechazada  
✅ Reciben notificación en tiempo real (sin refrescar)  
✅ Pueden ver historial en `/notifications`  

## 💻 Para Correr Localmente

```bash
# 1. Instalar dependencias
bundle install

# 2. Ejecutar migraciones
rails db:migrate

# 3. Iniciar servidor con WebSocket
bin/dev

# 4. Abrir navegador
http://localhost:3000
```

## 🔄 Flujo Automático de Notificaciones

### Cuando se crea una inscripción:
```ruby
# En inscripcion.rb - after_create :notify_admins_on_inscription
→ Envía notificación a TODOS los admins
→ Incluye Action Cable broadcast
→ Admin ve badge actualizado automáticamente
```

### Cuando se aprueba una inscripción:
```ruby
# En inscripcion.rb - after_update :notify_on_status_change
→ Si estado cambió a 'aprobada'
→ Envía notificación al usuario del estudiante
→ Usuario ve notificación en tiempo real
```

### Cuando se rechaza una inscripción:
```ruby
# Similar a aprobada
→ Usuario recibe notificación de rechazo
```

## 🎨 Personalización Rápida

### Cambiar duración del toast (popup)
`app/javascript/controllers/notifications_controller.js` línea ~65:
```javascript
setTimeout(() => {
  notificationDiv.classList.add("animate-slide-out")
}, 5000)  // ← Cambiar 5000 por milisegundos deseados
```

### Cambiar colores del dashboard
`app/views/pages/home.html.erb`:
```erb
<!-- Busca las clases Tailwind y cámbialas -->
bg-blue-600  → bg-purple-600
text-blue-600 → text-purple-600
```

## 🚨 Debugging

**No veo el badge:**
- Revisa que el usuario esté logueado
- Verifica `current_user.notifications.count`
- Limpia cache: Ctrl+Shift+Del

**Las notificaciones no llegan:**
- ¿Está corriendo `bin/dev`? (no `rails s`)
- Revisa consola del navegador (F12)
- Check WebSocket en Networks tab

**Error en migraciones:**
```bash
rails db:rollback
rails db:migrate
```

## 📚 Documentación Completa
Ver: `NOTIFICATIONS_SYSTEM.md` para guía técnica completa

## ✅ Checklist de Verificación

- [ ] `bin/dev` está corriendo
- [ ] Visitaste `http://localhost:3000` (ves dashboard)
- [ ] Eres admin: Ves badge de notificaciones
- [ ] Hiciste clic en badge: Se abre `/notifications`
- [ ] Pruebas crear inscripción: Admin recibe notificación
- [ ] Apruebas inscripción: Estudiante recibe notificación
- [ ] Aceptas notificaciones en tiempo real

## 🎉 ¡Listo!

El sistema está operativo. Los admins recibirán notificaciones automáticas cuando haya inscripciones pendientes, y los estudiantes recibirán notificaciones cuando se apruebe/rechace su inscripción.

---
**Última actualización**: Diciembre 2025
