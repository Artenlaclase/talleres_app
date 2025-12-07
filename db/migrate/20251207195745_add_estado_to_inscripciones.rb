class AddEstadoToInscripciones < ActiveRecord::Migration[8.1]
  def change
    add_column :inscripciones, :estado, :string, default: 'pendiente'
    add_index :inscripciones, :estado
  end
end
