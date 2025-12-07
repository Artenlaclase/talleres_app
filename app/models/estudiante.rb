class Estudiante < ApplicationRecord
  belongs_to :taller
  has_many :calificaciones, dependent: :destroy
  has_many :talleres_calificados, through: :calificaciones, source: :taller

  validates :nombre, presence: true
  validates :curso, presence: true
  validates :taller_id, presence: true

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
