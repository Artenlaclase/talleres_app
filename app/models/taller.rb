
class Taller < ApplicationRecord
  validates :nombre, presence: true
  validates :cupos, numericality: { greater_than: 0 }
  validates :descripcion, presence: true
  validates :fecha, presence: true

  has_many :estudiantes

end
