class Inscripcion < ApplicationRecord
  self.table_name = "inscripciones"
  
  belongs_to :estudiante
  belongs_to :taller

  # Estados de inscripción
  enum estado: { pendiente: 'pendiente', aprobada: 'aprobada', rechazada: 'rechazada' }

  validates :estudiante_id, uniqueness: { scope: :taller_id, message: "ya está inscrito en este taller" }
  validates :estado, inclusion: { in: %w(pendiente aprobada rechazada), message: "%{value} no es un estado válido" }
  validates :estudiante_id, :taller_id, presence: true
  
  # Scopes útiles
  scope :pendientes, -> { where(estado: 'pendiente') }
  scope :aprobadas, -> { where(estado: 'aprobada') }
  scope :rechazadas, -> { where(estado: 'rechazada') }
end
