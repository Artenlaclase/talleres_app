class CreateCalificaciones < ActiveRecord::Migration[8.0]
  def change
    create_table :calificaciones do |t|
      t.references :estudiante, null: false, foreign_key: true
      t.references :taller, null: false, foreign_key: true
      t.decimal :nota, precision: 5, scale: 2, null: false
      t.text :descripcion

      t.timestamps
    end

    add_index :calificaciones, [:estudiante_id, :taller_id], unique: true
  end
end
