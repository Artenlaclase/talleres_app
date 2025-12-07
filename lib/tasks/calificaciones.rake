namespace :calificaciones do
  desc "Crear calificaciones de ejemplo"
  task crear_ejemplo: :environment do
    Calificacion.delete_all
    
    estudiantes = Estudiante.all
    
    # Nombres de evaluaciones por orden
    nombres_evaluaciones = ['Prueba 1', 'Prueba 2', 'Tarea', 'Proyecto', 'Participación']
    
    notas_ejemplo = [6.5, 6.8, 5.0, 6.2, 7.0, 4.2, 6.0, 6.5, 6.2, 5.5, 6.0, 6.8, 5.8, 6.0, 6.5, 6.2]
    comentarios = [
      'Excelente desempeño, muy participativo',
      'Buena comprensión de conceptos',
      'Necesita mejorar en la práctica',
      'Muy dedicado y responsable',
      'Destaca en el análisis',
      'Buen trabajo general',
      'Muestra mucho potencial',
      'Trabajo consistente',
      'Sobresaliente en proyecto final',
      'Mejora notable en este taller'
    ]

    estudiantes.each_with_index do |e, i|
      taller = e.taller
      
      # Crear múltiples calificaciones por estudiante (hasta 5 evaluaciones)
      (1..3).each do |j|
        nota = notas_ejemplo[(i + j) % notas_ejemplo.length]
        comentario = comentarios[(i + j) % comentarios.length]
        nombre_eval = nombres_evaluaciones[(j - 1) % nombres_evaluaciones.length]
        
        Calificacion.create(
          estudiante_id: e.id,
          taller_id: taller.id,
          nota: nota,
          descripcion: comentario,
          nombre_evaluacion: nombre_eval
        )
        
        puts "✅ #{e.nombre} en #{taller.nombre} - #{nombre_eval}: #{nota}"
      end
    end

    puts "\n✅ Se crearon #{Calificacion.count} calificaciones de ejemplo"
  end
end
