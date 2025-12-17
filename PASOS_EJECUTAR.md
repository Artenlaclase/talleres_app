# 🚀 PASOS PARA EJECUTAR - Sistema de Notificaciones

## ⚠️ IMPORTANTE

Debes usar **`bin/dev`** y NO `rails s` porque el sistema necesita WebSocket (Action Cable).

---

## 📋 Paso 1: Instalar Dependencias

```powershell
# En PowerShell
bundle install
npm install
```

**Salida esperada:**
```
Resolving dependencies...
Bundle complete! XX gems in X seconds
added XXX packages
```

---

## 📦 Paso 2: Ejecutar Migraciones (CRÍTICO)

```powershell
rails db:migrate
```

**Salida esperada:**
```
== 20250101000001 CreateNotifications: migrating =======================
-- create_table(:notifications)
   -> 0.0234s
== 20250101000001 CreateNotifications: migrated (0.0235s) ==============
```

**Verificar que se creó:**
```powershell
rails dbconsole

# En el prompt sqlite3, escribe:
.tables

# Debe mostrar (incluyendo otras):
# notifications  users  talleres  estudiantes  ...
```

---

## 🔧 Paso 3: Compilar Assets (Opcional, se hace automático)

```powershell
npm run build:css
```

---

## 🌐 Paso 4: Iniciar Servidor

```powershell
# ⚠️ CRÍTICO: Usa bin/dev, NO rails s

bin/dev
```

**Salida esperada:**
```
12:45:07 - INFO - started server with pid 1234
12:45:09 - INFO - compiled assets
12:45:10 - INFO - Started Action Cable server

Visit http://localhost:3000
```

**Espera hasta que veas todos estos mensajes:**
- ✅ `started server with pid`
- ✅ `compiled assets`
- ✅ `Started Action Cable server`

---

## 📱 Paso 5: Abrir Navegador

```
http://localhost:3000
```

**Deberías ver:**
- ✅ Dashboard con estadísticas (4 cards)
- ✅ Si eres admin: Badge 🔔 en navbar
- ✅ Si eres admin: Panel Admin en home

---

## 🧪 Paso 6: Pruebas de Funcionamiento

### Prueba 1: Ver Estadísticas
```
1. Abre http://localhost:3000 en navegador
2. Verifica que ves 4 tarjetas:
   ├─ Total Talleres
   ├─ Total Estudiantes
   ├─ Inscripciones Pendientes
   └─ Inscripciones Aprobadas
```

### Prueba 2: Crear Usuario Admin
```powershell
# En otra terminal
rails console

# Dentro de rails console
user = User.create!(
  email: "admin@test.com",
  password: "password123",
  password_confirmation: "password123",
  role: "admin"
)

# Salida: => #<User id=1, email: "admin@test.com"...>
```

### Prueba 3: Loguear como Admin
```
1. Cierra sesión actual (si estabas logueado)
2. Haz clic en "Iniciar sesión"
3. Email: admin@test.com
4. Password: password123
5. Haz clic en "Sign In"

Deberías ver:
├─ Dashboard con estadísticas
├─ Badge 🔔 en navbar (parte superior derecha)
├─ Panel Admin en home
│  └─ Notificaciones Recientes
│  └─ Acciones Rápidas
└─ Actividad Reciente
```

### Prueba 4: Crear Inscripción
```
1. Ve a "Talleres" (en navbar)
2. Haz clic en un taller
3. Haz clic en "Nueva Inscripción" o similar
4. Selecciona un estudiante
5. Haz clic en "Create"

Deberías:
├─ Ver mensaje "Inscripción creada"
├─ Recibir notificación automática (toast en esquina)
└─ Ver badge actualizado [1]
```

### Prueba 5: Ver Centro de Notificaciones
```
1. Haz clic en el badge 🔔 en navbar
2. Se abre http://localhost:3000/notifications
3. Deberías ver la inscripción creada

En la notificación:
├─ Título: "Nueva Inscripción Pendiente"
├─ Mensaje: con nombre del estudiante y taller
├─ Icono: ⏳ (reloj amarillo)
├─ Botón: [Marcar como leída]
└─ Botón: [Eliminar]
```

### Prueba 6: Marcar como Leída
```
1. En /notifications, haz clic en [Marcar como leída]
2. La notificación cambia de estilo
3. El badge desaparece (o disminuye el número)
```

### Prueba 7: Notificaciones en Tiempo Real
```
1. Abre TWO pestañas:
   - Tab 1: http://localhost:3000/notifications
   - Tab 2: http://localhost:3000 (home)

2. En Tab 2: Crea una nueva inscripción

3. En Tab 1: 
   - Sin refrescar la página
   - Debería aparecer la notificación
   - Con animación slide-in
   - Desaparece después de 5 segundos

4. Si NO aparece:
   - Revisa F12 (Console)
   - Busca errores de WebSocket
   - Verifica que bin/dev está corriendo
```

### Prueba 8: Aprobar Inscripción
```
1. Ve a "Inscripciones" (navbar admin)
2. Busca una inscripción en estado "Pendiente"
3. Haz clic en "Aprobar"

4. Automáticamente:
   - La inscripción cambia a estado "Aprobada"
   - Se crea una notificación para el estudiante
   - El estudiante la recibe en tiempo real
```

---

## 🔍 Troubleshooting

### ❌ Error: "WebSocket is not connected"

**Causa**: No estás usando `bin/dev`

**Solución**:
```powershell
# Detén el servidor (Ctrl+C)

# Asegúrate de que NO hay otro servidor corriendo
Get-Process -Name "rails" | Stop-Process

# Reinicia con bin/dev
bin/dev
```

### ❌ Error: "Migraciones no aplicadas"

**Causa**: Olvidaste ejecutar `rails db:migrate`

**Solución**:
```powershell
rails db:migrate

# Verifica
rails db:migrate:status

# Debe mostrar "up" para CreateNotifications
```

### ❌ Badge no se actualiza

**Causa**: La notificación no se broadcast correctamente

**Solución**:
```powershell
# En navegador F12 Console, ejecuta:
fetch('/notifications/unread_count')
  .then(r => r.json())
  .then(d => console.log(d))

# Debe mostrar: {count: XX}
```

### ❌ No veo notificaciones en tiempo real

**Causa**: Action Cable no está corriendo

**Solución**:
```powershell
# En bin/dev output, busca:
# "Started Action Cable server"

# Si no está, bin/dev no se ejecutó correctamente
```

### ❌ Error: "No route matches"

**Causa**: Rutas no se recargaron

**Solución**:
```powershell
# Detén bin/dev (Ctrl+C)
# Espera 2 segundos
# Reinicia: bin/dev
```

---

## 📊 Verificar que Todo Funciona

```powershell
# En terminal, ejecuta:
rails routes | grep notification

# Deberías ver:
# notifications          GET    /notifications
# notification           GET    /notifications/:id
# mark_as_read_notification PATCH /notifications/:id/mark_as_read
# notification           DELETE /notifications/:id
# unread_count_notifications GET  /notifications/unread_count
```

---

## 📝 Logs Útiles

### Ver logs de Action Cable
En el output de `bin/dev`, busca líneas con:
```
[ActionCable] websocket connection established
[ActionCable] NotificationsChannel subscribed
[ActionCable] Broadcasting to notifications:USER_ID
```

### Ver logs de BD
En Rails console:
```powershell
rails console

# Dentro de rails console
Notification.last(5).map { |n| "#{n.title} - #{n.user.email}" }
```

### Ver logs de WebSocket en navegador
```javascript
// En navegador F12 Console
localStorage.setItem('debug', '*');
// Recarga la página
```

---

## ✅ Checklist Final

- [ ] `bundle install` completado
- [ ] `npm install` completado
- [ ] `rails db:migrate` completado
- [ ] `bin/dev` corriendo (sin `rails s`)
- [ ] Navegador en http://localhost:3000
- [ ] Loguado como admin
- [ ] Badge 🔔 visible en navbar
- [ ] Dashboard con 4 estadísticas visible
- [ ] Panel Admin visible
- [ ] Creé una inscripción de prueba
- [ ] Recibí notificación automática
- [ ] Centro de notificaciones funcionando
- [ ] Notificaciones en tiempo real funcionando

---

## 🎉 ¡TODO LISTO!

Si completaste el checklist anterior:

```
┌─────────────────────────────────────────────┐
│  ✅ SISTEMA OPERATIVO                      │
│                                             │
│  El sistema de notificaciones está         │
│  100% funcional y listo para usar          │
│                                             │
│  Próximo paso: Consulta la documentación  │
│  - GUIA_NOTIFICACIONES_RAPIDA.md           │
│  - NOTIFICATIONS_SYSTEM.md                  │
│  - CODE_EXAMPLES.md                        │
└─────────────────────────────────────────────┘
```

---

**Documentación**: Ver otros archivos .md en la raíz del proyecto  
**Soporte**: Revisar `VERIFICACION_CHECKLIST.md` para debugging
