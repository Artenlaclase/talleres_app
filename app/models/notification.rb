class Notification < ApplicationRecord
  belongs_to :user
  has_one :inscripcion, optional: true, dependent: :nullify

  # Estados de notificación
  enum :notification_type, { 
    inscripcion_pendiente: 'inscripcion_pendiente', 
    inscripcion_aprobada: 'inscripcion_aprobada',
    inscripcion_rechazada: 'inscripcion_rechazada',
    taller_modificado: 'taller_modificado',
    sistema: 'sistema'
  }, default: :sistema

  validates :user_id, :title, :notification_type, presence: true

  # Scopes
  scope :sin_leer, -> { where(read_at: nil) }
  scope :por_fecha, -> { order(created_at: :desc) }
  scope :recientes, -> { por_fecha.limit(10) }

  # Marcar como leída
  def mark_as_read
    update(read_at: Time.current) unless read?
  end

  def read?
    read_at.present?
  end

  def unread?
    !read?
  end
end
