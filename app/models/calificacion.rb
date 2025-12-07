class Calificacion < ApplicationRecord
  self.table_name = "calificaciones"
  
  belongs_to :estudiante
  belongs_to :taller

  validates :nota, presence: true, numericality: { greater_than_or_equal_to: 1.0, less_than_or_equal_to: 7.0 }
  validates :estudiante_id, presence: true
  validates :taller_id, presence: true
  validates :nombre_evaluacion, presence: true, length: { minimum: 3, maximum: 50 }
  validate :estudiante_pertenece_taller
  validate :no_excede_numero_evaluaciones

  private

  def estudiante_pertenece_taller
    return unless estudiante && taller
    unless estudiante.taller_id == taller.id
      errors.add(:base, "El estudiante no está inscrito en este taller")
    end
  end

  def no_excede_numero_evaluaciones
    return unless estudiante && taller
    
    # Contar calificaciones existentes (excluyendo la actual si estamos editando)
    count = Calificacion.where(estudiante_id: estudiante_id, taller_id: taller_id)
    count = count.where.not(id: id) if persisted?
    
    if count.count >= taller.numero_evaluaciones
      errors.add(:base, "Este estudiante ya tiene #{taller.numero_evaluaciones} calificaciones en este taller")
    end
  end
end
