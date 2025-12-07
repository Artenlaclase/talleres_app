class AddMaxTalleresPorPeriodoToEstudiantes < ActiveRecord::Migration[8.1]
  def change
    add_column :estudiantes, :max_talleres_por_periodo, :integer, default: 3
  end
end
