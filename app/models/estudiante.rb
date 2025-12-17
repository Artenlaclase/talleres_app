class Estudiante < ApplicationRecord
  belongs_to :taller, optional: true  # Opcional - usar inscripciones como fuente principal
  belongs_to :user, optional: true
  has_many :calificaciones, dependent: :destroy, class_name: "Calificacion"
  has_many :talleres_calificados, through: :calificaciones, source: :taller
  has_many :inscripciones, dependent: :destroy, class_name: "Inscripcion"
  has_many :talleres_inscritos, through: :inscripciones, source: :taller

  validates :nombre, presence: true, length: { minimum: 2, maximum: 100 }
  validates :curso, presence: true
  validates :max_talleres_por_periodo, numericality: { greater_than: 0, only_integer: true }, allow_nil: true

  # Scopes
  scope :orden_nombre, -> { order(nombre: :asc) }
  scope :por_curso, ->(curso) { where(curso: curso) }
  scope :sin_calificaciones, -> { left_outer_joins(:calificaciones).where(calificaciones: { id: nil }).distinct }

  # Métodos principales - usar inscripciones como fuente
  def talleres_activos
    talleres_inscritos.where(inscripciones: { estado: 'aprobada' })
  end

  def talleres_pendientes
    talleres_inscritos.where(inscripciones: { estado: 'pendiente' })
  end

  def cupos_alcanzados?
    return false unless max_talleres_por_periodo
    inscripciones.where(estado: 'aprobada').count >= max_talleres_por_periodo
  end

  def puede_inscribirse?
    !cupos_alcanzados?
  end
end
