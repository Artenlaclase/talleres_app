class RefactorStudentTallerRelation < ActiveRecord::Migration[8.1]
  def change
    # Eliminar validación de taller_id requerido (será nullable)
    change_column_null :estudiantes, :taller_id, true
    
    # Crear índice compuesto para calificaciones (permite múltiples evaluaciones)
    remove_index :calificaciones, [:estudiante_id, :taller_id], if_exists: true
    add_index :calificaciones, [:estudiante_id, :taller_id, :nombre_evaluacion], 
              unique: true, name: "idx_calificaciones_estudiante_taller_evaluacion"
  end
end
