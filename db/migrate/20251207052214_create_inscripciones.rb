class CreateInscripciones < ActiveRecord::Migration[8.1]
  def change
    create_table :inscripciones do |t|
      t.references :estudiante, null: false, foreign_key: true
      t.references :taller, null: false, foreign_key: true
    end
    
    # Índice único para evitar inscripciones duplicadas
    add_index :inscripciones, [:estudiante_id, :taller_id], unique: true
  end
end
