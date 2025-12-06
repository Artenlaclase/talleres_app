class AddTallerToEstudiantes < ActiveRecord::Migration[8.1]
  def change
    add_reference :estudiantes, :taller, null: false, foreign_key: true
  end
end
