class CreateEstudiantes < ActiveRecord::Migration[8.1]
  def change
    create_table :estudiantes do |t|
      t.string :nombre
      t.string :curso

      t.timestamps
    end
  end
end
