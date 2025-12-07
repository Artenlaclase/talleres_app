
class Taller < ApplicationRecord
  validates :nombre, presence: true
  validates :cupos, numericality: { greater_than: 0 }
  validates :descripcion, presence: true
  validates :fecha, presence: true

  has_many :estudiantes, dependent: :restrict_with_error
  has_many :calificaciones, dependent: :destroy, class_name: "Calificacion"
  has_many :estudiantes_calificados, through: :calificaciones, source: :estudiante
  has_many :inscripciones, dependent: :destroy, class_name: "Inscripcion"
  has_many :estudiantes_inscritos, through: :inscripciones, source: :estudiante

  def cupos_restantes
    inscritos = estudiantes.count + inscripciones.count
    [cupos - inscritos, 0].max
  end

  validate :cupos_no_menor_a_inscritos

  private

  def cupos_no_menor_a_inscritos
    return if cupos.nil?
    inscritos = estudiantes.count
    if cupos < inscritos
      errors.add(:cupos, "No puede ser menor que los estudiantes inscritos (#{inscritos}).")
    end
  end

end
