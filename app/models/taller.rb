
class Taller < ApplicationRecord
  validates :nombre, presence: true, length: { minimum: 3, maximum: 100 }
  validates :cupos, numericality: { greater_than: 0, only_integer: true }
  validates :descripcion, presence: true, length: { minimum: 10 }
  validates :fecha, presence: true
  validates :numero_evaluaciones, numericality: { greater_than: 0, only_integer: true }, allow_nil: true

  has_many :estudiantes, dependent: :restrict_with_error
  has_many :calificaciones, dependent: :destroy, class_name: "Calificacion"
  has_many :estudiantes_calificados, through: :calificaciones, source: :estudiante
  has_many :inscripciones, dependent: :destroy, class_name: "Inscripcion"
  has_many :estudiantes_inscritos, through: :inscripciones, source: :estudiante

  # Scopes
  scope :proximos, -> { where('fecha >= ?', Date.today).order(fecha: :asc) }
  scope :pasados, -> { where('fecha < ?', Date.today).order(fecha: :desc) }
  scope :con_cupo, -> { where('cupos > 0') }
  scope :orden_alfabetico, -> { order(nombre: :asc) }

  def cupos_restantes
    inscritos = estudiantes.count + inscripciones.aprobadas.count
    [cupos - inscritos, 0].max
  end

  def cupo_disponible?
    cupos_restantes > 0
  end

  def total_inscritos
    estudiantes.count + inscripciones.aprobadas.count
  end

  validate :cupos_no_menor_a_inscritos

  private

  def cupos_no_menor_a_inscritos
    return if cupos.nil?
    inscritos = estudiantes.count + inscripciones.aprobadas.count
    if cupos < inscritos
      errors.add(:cupos, "No puede ser menor que los estudiantes inscritos (#{inscritos}).")
    end
  end
end
