class Calificacion < ApplicationRecord
  belongs_to :estudiante
  belongs_to :taller

  validates :nota, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :estudiante_id, presence: true
  validates :taller_id, presence: true
  validate :estudiante_pertenece_taller

  private

  def estudiante_pertenece_taller
    return unless estudiante && taller
    unless estudiante.taller_id == taller.id
      errors.add(:base, "El estudiante no está inscrito en este taller")
    end
  end
end
