
class Taller < ApplicationRecord
  validates :nombre, presence: true
  validates :cupos, numericality: { greater_than: 0 }
  validates :descripcion, presence: true
  validates :fecha, presence: true

  has_many :estudiantes, dependent: :restrict_with_error

  def cupos_restantes
    [cupos - estudiantes.count, 0].max
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
