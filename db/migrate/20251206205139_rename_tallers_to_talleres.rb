class RenameTallersToTalleres < ActiveRecord::Migration[8.1]
  def change
    rename_table :tallers, :talleres
  end
end
