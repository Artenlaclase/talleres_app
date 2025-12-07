class Inscripcion < ApplicationRecord
  self.table_name = "inscripciones"
  
  belongs_to :estudiante
  belongs_to :taller

  validates :estudiante_id, uniqueness: { scope: :taller_id, message: "ya está inscrito en este taller" }
end
