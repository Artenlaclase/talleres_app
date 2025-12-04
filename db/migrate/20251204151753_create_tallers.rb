class CreateTallers < ActiveRecord::Migration[8.1]
  def change
    create_table :tallers do |t|
      t.string :nombre
      t.text :descripcion
      t.integer :cupos

      t.timestamps
    end
  end
end
