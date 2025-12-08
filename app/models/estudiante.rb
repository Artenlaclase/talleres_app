class Estudiante < ApplicationRecord
  belongs_to :taller
  belongs_to :user, optional: true
  has_many :calificaciones, dependent: :destroy, class_name: "Calificacion"
  has_many :talleres_calificados, through: :calificaciones, source: :taller
  has_many :inscripciones, dependent: :destroy, class_name: "Inscripcion"
  has_many :talleres_inscritos, through: :inscripciones, source: :taller

  validates :nombre, presence: true, length: { minimum: 2, maximum: 100 }
  validates :curso, presence: true
  validates :taller_id, presence: true
  validates :max_talleres_por_periodo, numericality: { greater_than: 0, only_integer: true }, allow_nil: true

  # Scopes
  scope :orden_nombre, -> { order(nombre: :asc) }
  scope :por_curso, ->(curso) { where(curso: curso) }
  scope :sin_calificaciones, -> { left_outer_joins(:calificaciones).where(calificaciones: { id: nil }).distinct }

  def talleres_activos
    [taller] + talleres_inscritos.where(inscripciones: { estado: 'aprobada' })
  end

  def talleres_pendientes
    talleres_inscritos.where(inscripciones: { estado: 'pendiente' })
  end

  validate :taller_con_cupo_disponible

  private

  def taller_con_cupo_disponible
    return unless taller
    # Recalcular desde la base para evitar condiciones de carrera
    inscritos = Estudiante.where(taller_id: taller_id).count
    if inscritos >= taller.cupos
      errors.add(:taller_id, "El taller no tiene cupos disponibles")
    end
  end
end
