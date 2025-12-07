class AddNumeroEvaluacionesToTallers < ActiveRecord::Migration[8.1]
  def change
    # Remover índice único para permitir múltiples calificaciones por estudiante/taller
    remove_index :calificaciones, [:estudiante_id, :taller_id], if_exists: true
    
    # Agregar el nuevo campo
    add_column :talleres, :numero_evaluaciones, :integer, default: 5
  end
end
