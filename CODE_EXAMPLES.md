# 💻 Ejemplos de Código - Sistema de Notificaciones

## Tabla de Contenidos
1. [Crear Notificaciones](#crear-notificaciones)
2. [Consultar Notificaciones](#consultar-notificaciones)
3. [Actualizar Estado](#actualizar-estado)
4. [Broadcasting en Tiempo Real](#broadcasting-en-tiempo-real)
5. [Desde Controladores](#desde-controladores)
6. [Desde Modelos](#desde-modelos)

---

## Crear Notificaciones

### Notificación Simple
```ruby
# En cualquier lugar (controller, modelo, service, etc)
user = User.find(1)

notification = user.notifications.create(
  title: "Bienvenido",
  message: "Gracias por registrarte en TalleresApp",
  notification_type: :sistema
)

puts notification.id  # => 42
```

### Notificación con Relación a Inscripción
```ruby
inscripcion = Inscripcion.find(1)
user = User.find(1)

notification = user.notifications.create(
  title: "Nueva Inscripción",
  message: "Usuario se inscribió en #{inscripcion.taller.nombre}",
  notification_type: :inscripcion_pendiente,
  inscripcion: inscripcion  # ← Relación
)
```

### Crear para Múltiples Usuarios
```ruby
# Para todos los admins
admins = User.admins

admins.each do |admin|
  admin.notifications.create(
    title: "Inscripción Pendiente",
    message: "Nueva inscripción de #{estudiante.nombre}",
    notification_type: :inscripcion_pendiente,
    inscripcion: inscripcion
  )
end

# Para todos los usuarios activos
User.activos.each do |user|
  user.notifications.create(
    title: "Anuncio del Sistema",
    message: "El sistema estará en mantenimiento",
    notification_type: :sistema
  )
end
```

---

## Consultar Notificaciones

### Notificaciones Sin Leer
```ruby
current_user.notifications.sin_leer
# => #<ActiveRecord::Relation [#<Notification...>, ...]>

# Contar
current_user.notifications.sin_leer.count  # => 5

# Cada una
current_user.notifications.sin_leer.each do |notif|
  puts "#{notif.title}: #{notif.message}"
end
```

### Notificaciones Ordenadas por Fecha
```ruby
# Más recientes primero
current_user.notifications.por_fecha
# => Ordenadas por created_at DESC

# Reverse
current_user.notifications.por_fecha.reverse
# => Más antiguas primero
```

### Las 10 Más Recientes
```ruby
recent = current_user.notifications.recientes
# => SELECT * FROM notifications WHERE user_id=? 
#    ORDER BY created_at DESC LIMIT 10

recent.each do |notif|
  puts notif.title
end
```

### Filtrar por Tipo
```ruby
# Todas las notificaciones de inscripciones pendientes
current_user.notifications
  .where(notification_type: :inscripcion_pendiente)

# En un scope
current_user.notifications
  .where(notification_type: [:inscripcion_aprobada, :inscripcion_rechazada])
```

### Filtrar por Leída/Sin Leer
```ruby
# Sin leer
sin_leer = current_user.notifications
  .where(read_at: nil)

# Leída
leidas = current_user.notifications
  .where.not(read_at: nil)

# Leídas en los últimos 7 días
semana_pasada = current_user.notifications
  .where(read_at: 7.days.ago..Time.current)
```

### Con Relación a Inscripción
```ruby
# Notificaciones de una inscripción específica
inscripcion = Inscripcion.find(1)
inscripcion.notification
# => #<Notification id=42...>

# Todas las notificaciones con inscripción relacionada
Notification.where.not(inscripcion_id: nil)

# Notificaciones de una inscripción
Notification.where(inscripcion_id: inscripcion.id)
```

---

## Actualizar Estado

### Marcar Como Leída
```ruby
notification = current_user.notifications.first

# Método directo
notification.mark_as_read
# => UPDATE notifications SET read_at=? WHERE id=?

# Verificar
notification.read?   # => true
notification.unread? # => false
```

### Marcar Múltiples Como Leídas
```ruby
# Todas las sin leer
current_user.notifications.sin_leer.update_all(read_at: Time.current)

# Las de cierto tipo
current_user.notifications
  .where(notification_type: :inscripcion_pendiente)
  .update_all(read_at: Time.current)
```

### Eliminar Notificaciones
```ruby
notification = current_user.notifications.first

# Eliminar una
notification.destroy
# => DELETE FROM notifications WHERE id=?

# Eliminar todas sin leer
current_user.notifications.sin_leer.destroy_all

# Eliminar más antiguas de 30 días
Notification.where("created_at < ?", 30.days.ago).destroy_all
```

---

## Broadcasting en Tiempo Real

### Notificar Usuario Individual
```ruby
user = User.find(1)

notification = user.notifications.create(
  title: "Inscripción Aprobada",
  message: "Tu inscripción fue aprobada",
  notification_type: :inscripcion_aprobada
)

# Broadcast en tiempo real
ActionCable.server.broadcast(
  "notifications:#{user.id}",
  action: "new_notification",
  data: {
    id: notification.id,
    title: notification.title,
    message: notification.message,
    type: notification.notification_type
  }
)
```

### Notificar Múltiples Usuarios
```ruby
admins = User.admins
inscripcion = Inscripcion.find(1)

admins.each do |admin|
  notification = admin.notifications.create(
    title: "Nueva Inscripción",
    message: "Inscripción pendiente de aprobación",
    notification_type: :inscripcion_pendiente,
    inscripcion: inscripcion
  )

  ActionCable.server.broadcast(
    "notifications:#{admin.id}",
    action: "new_notification",
    data: {
      id: notification.id,
      title: notification.title,
      message: notification.message,
      type: notification.notification_type
    }
  )
end
```

### Marcar Como Leída (broadcast)
```ruby
notification = Notification.find(42)

notification.mark_as_read

ActionCable.server.broadcast(
  "notifications:#{notification.user_id}",
  action: "notification_read",
  data: {
    notification_id: notification.id
  }
)
```

---

## Desde Controladores

### En InscripcionesController
```ruby
class InscripcionesController < ApplicationController
  def approve
    @inscripcion = Inscripcion.find(params[:id])
    
    if @inscripcion.update(estado: 'aprobada')
      # Notificar al estudiante
      if @inscripcion.estudiante.user
        notify_inscription_approved(@inscripcion)
      end
      
      redirect_to inscripciones_path, notice: "Inscripción aprobada"
    end
  end

  private

  def notify_inscription_approved(inscripcion)
    user = inscripcion.estudiante.user
    
    notification = user.notifications.create(
      title: "Inscripción Aprobada",
      message: "Tu inscripción a #{inscripcion.taller.nombre} fue aprobada",
      notification_type: :inscripcion_aprobada,
      inscripcion: inscripcion
    )

    ActionCable.server.broadcast(
      "notifications:#{user.id}",
      action: "new_notification",
      data: {
        id: notification.id,
        title: notification.title,
        message: notification.message,
        type: notification.notification_type
      }
    )
  end
end
```

### En NotificationsController
```ruby
class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.por_fecha
    @unread_count = current_user.notifications.sin_leer.count
    
    # Marcar todo como leído al entrar
    current_user.notifications.sin_leer.update_all(read_at: Time.current)
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read
    
    redirect_back notice: "Notificación marcada como leída"
  end

  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy
    
    redirect_back notice: "Notificación eliminada"
  end
end
```

---

## Desde Modelos

### En Inscripcion Model
```ruby
class Inscripcion < ApplicationRecord
  after_create :notify_admins_on_inscription
  after_update :notify_on_status_change

  private

  def notify_admins_on_inscription
    if pendiente?
      message = "#{estudiante.nombre} se inscribió a #{taller.nombre}"
      
      User.admins.each do |admin|
        notification = admin.notifications.create!(
          title: "Nueva Inscripción Pendiente",
          message: message,
          notification_type: :inscripcion_pendiente,
          inscripcion: self
        )

        broadcast_notification(admin, notification)
      end
    end
  end

  def notify_on_status_change
    return unless estado_changed?
    return unless estudiante.user

    case estado
    when 'aprobada'
      notify_approved
    when 'rechazada'
      notify_rejected
    end
  end

  def notify_approved
    notification = estudiante.user.notifications.create!(
      title: "Inscripción Aprobada",
      message: "Tu inscripción a #{taller.nombre} fue aprobada",
      notification_type: :inscripcion_aprobada,
      inscripcion: self
    )
    broadcast_notification(estudiante.user, notification)
  end

  def notify_rejected
    notification = estudiante.user.notifications.create!(
      title: "Inscripción Rechazada",
      message: "Tu inscripción a #{taller.nombre} fue rechazada",
      notification_type: :inscripcion_rechazada,
      inscripcion: self
    )
    broadcast_notification(estudiante.user, notification)
  end

  def broadcast_notification(user, notification)
    ActionCable.server.broadcast(
      "notifications:#{user.id}",
      action: "new_notification",
      data: {
        id: notification.id,
        title: notification.title,
        message: notification.message,
        type: notification.notification_type
      }
    )
  end
end
```

### En Service Class
```ruby
class NotificationService
  def self.notify_inscription_created(inscripcion)
    message = "#{inscripcion.estudiante.nombre} se inscribió a #{inscripcion.taller.nombre}"
    
    User.admins.find_each do |admin|
      create_and_broadcast(
        user: admin,
        title: "Nueva Inscripción",
        message: message,
        type: :inscripcion_pendiente,
        inscripcion: inscripcion
      )
    end
  end

  def self.notify_inscription_status(inscripcion, status)
    return unless inscripcion.estudiante.user

    case status
    when :approved
      create_and_broadcast(
        user: inscripcion.estudiante.user,
        title: "Inscripción Aprobada",
        message: "Tu inscripción fue aprobada",
        type: :inscripcion_aprobada,
        inscripcion: inscripcion
      )
    end
  end

  private

  def self.create_and_broadcast(user:, title:, message:, type:, inscripcion: nil)
    notification = user.notifications.create!(
      title: title,
      message: message,
      notification_type: type,
      inscripcion: inscripcion
    )

    ActionCable.server.broadcast(
      "notifications:#{user.id}",
      action: "new_notification",
      data: {
        id: notification.id,
        title: notification.title,
        message: notification.message,
        type: notification.notification_type
      }
    )
  end
end

# Uso
NotificationService.notify_inscription_created(inscripcion)
NotificationService.notify_inscription_status(inscripcion, :approved)
```

---

## Ejemplos en Vistas

### Ver si hay notificaciones sin leer
```erb
<% if current_user.notifications.sin_leer.any? %>
  <span class="badge badge-red">
    <%= current_user.notifications.sin_leer.count %>
  </span>
<% end %>
```

### Listar notificaciones recientes
```erb
<% current_user.notifications.recientes.each do |notification| %>
  <div class="notification <%= 'unread' if notification.unread? %>">
    <h4><%= notification.title %></h4>
    <p><%= notification.message %></p>
    <small><%= time_ago_in_words(notification.created_at) %></small>
  </div>
<% end %>
```

### Botón para marcar todas como leídas
```erb
<%= button_to "Marcar todas como leídas", 
    mark_all_as_read_notifications_path, 
    method: :patch %>
```

---

## Testing (RSpec)

```ruby
describe Notification do
  let(:user) { create(:user) }

  describe "#create" do
    it "creates a notification" do
      expect {
        user.notifications.create(
          title: "Test",
          message: "Test message",
          notification_type: :sistema
        )
      }.to change(Notification, :count).by(1)
    end
  end

  describe "#scopes" do
    before do
      user.notifications.create!(
        title: "N1",
        message: "M1",
        notification_type: :sistema
      )
      user.notifications.create!(
        title: "N2",
        message: "M2",
        notification_type: :sistema,
        read_at: Time.current
      )
    end

    it "returns unread notifications" do
      expect(user.notifications.sin_leer.count).to eq(1)
    end

    it "returns notifications by date" do
      expect(user.notifications.por_fecha.first.read_at).to be_present
    end
  end
end
```

---

**Para más ejemplos, revisar los archivos:**
- `app/models/notification.rb`
- `app/models/inscripcion.rb`
- `app/controllers/notifications_controller.rb`
- `NOTIFICATIONS_SYSTEM.md`
