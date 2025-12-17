class Inscripcion < ApplicationRecord
  self.table_name = "inscripciones"
  
  belongs_to :estudiante
  belongs_to :taller
  has_one :notification, dependent: :nullify

  # Estados de inscripción
  enum :estado, { pendiente: 'pendiente', aprobada: 'aprobada', rechazada: 'rechazada' }, default: :pendiente

  validates :estudiante_id, uniqueness: { scope: :taller_id, message: "ya está inscrito en este taller" }
  validates :estado, inclusion: { in: %w(pendiente aprobada rechazada), message: "%{value} no es un estado válido" }
  validates :estudiante_id, :taller_id, presence: true
  
  # Callbacks para notificaciones
  after_create :notify_admins_on_inscription
  after_update :notify_on_status_change

  # Scopes útiles
  scope :pendientes, -> { where(estado: 'pendiente') }
  scope :aprobadas, -> { where(estado: 'aprobada') }
  scope :rechazadas, -> { where(estado: 'rechazada') }

  private

  # Notificar a admins cuando hay una nueva inscripción pendiente
  def notify_admins_on_inscription
    if pendiente?
      message = "#{estudiante.nombre} se ha inscrito al taller \"#{taller.nombre}\" y está pendiente de aprobación"
      
      User.admins.each do |admin|
        notification = admin.notifications.create(
          title: "Nueva Inscripción Pendiente",
          message: message,
          notification_type: :inscripcion_pendiente,
          inscripcion: self
        )
        
        # Broadcast en tiempo real
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
    end
  end

  # Notificar cambios de estado
  def notify_on_status_change
    # Solo notificar si el estado cambió
    return unless estado_changed?

    estudiante_user = estudiante.user
    return unless estudiante_user

    case estado
    when 'aprobada'
      notify_inscription_approved(estudiante_user)
    when 'rechazada'
      notify_inscription_rejected(estudiante_user)
    end
  end

  def notify_inscription_approved(user)
    message = "Tu inscripción al taller \"#{taller.nombre}\" ha sido aprobada"
    
    notification = user.notifications.create(
      title: "Inscripción Aprobada",
      message: message,
      notification_type: :inscripcion_aprobada,
      inscripcion: self
    )
    
    # Broadcast
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

  def notify_inscription_rejected(user)
    message = "Tu inscripción al taller \"#{taller.nombre}\" ha sido rechazada"
    
    notification = user.notifications.create(
      title: "Inscripción Rechazada",
      message: message,
      notification_type: :inscripcion_rechazada,
      inscripcion: self
    )
    
    # Broadcast
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
