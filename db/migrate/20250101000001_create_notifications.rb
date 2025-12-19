class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :inscripcion, null: true, foreign_key: { to_table: :inscripciones }

      t.string :title, null: false
      t.text :message
      t.string :notification_type, default: 'sistema', null: false

      t.datetime :read_at
      t.datetime :created_at, default: -> { 'CURRENT_TIMESTAMP' }, null: false
      t.datetime :updated_at, default: -> { 'CURRENT_TIMESTAMP' }, null: false

      t.index [:user_id, :created_at]
      t.index [:user_id, :read_at]
    end
  end
end
