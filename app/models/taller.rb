
class Taller < ApplicationRecord
  validates :nombre, presence: true
  validates :cupos, numericality: { greater_than: 0 }
end
