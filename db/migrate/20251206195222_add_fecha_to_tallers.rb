class AddFechaToTallers < ActiveRecord::Migration[8.1]
  def change
    add_column :tallers, :fecha, :date
  end
end
