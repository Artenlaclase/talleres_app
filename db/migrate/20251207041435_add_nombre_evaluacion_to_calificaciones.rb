class AddNombreEvaluacionToCalificaciones < ActiveRecord::Migration[8.1]
  def change
    add_column :calificaciones, :nombre_evaluacion, :string
  end
end
