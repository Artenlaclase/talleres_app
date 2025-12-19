class FixNotificationsInscripcionForeignKey < ActiveRecord::Migration[8.0]
  def change
    # Eliminar la foreign key incorrecta
    remove_foreign_key :notifications, column: :inscripcion_id, if_exists: true
    
    # Recrear con el nombre correcto
    add_foreign_key :notifications, :inscripciones, column: :inscripcion_id, on_delete: :cascade
  end
end
