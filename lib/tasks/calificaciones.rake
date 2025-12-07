namespace :calificaciones do
  desc "Crear calificaciones de ejemplo"
  task crear_ejemplo: :environment do
    Calificacion.delete_all
    
    estudiantes = Estudiante.all
    
    # Nombres de evaluaciones por orden
    nombres_evaluaciones = ['Prueba 1', 'Prueba 2', 'Tarea', 'Proyecto', 'Participación']
    
    # Temas de evaluación
    temas_por_taller = {
      'Introducción a Rails' => ['MVC y Scaffolding', 'Modelos y Asociaciones', 'Validaciones y Callbacks', 'REST APIs', 'Seguridad'],
      'Tailwind CSS Avanzado' => ['Componentes personalizados', 'Responsive Design', 'Animaciones', 'Performance', 'Integración'],
      'APIs REST con Rails' => ['Endpoints CRUD', 'Autenticación', 'Paginación', 'Errores HTTP', 'Documentación'],
      'Arte' => ['Técnica básica', 'Composición', 'Color', 'Perspectiva', 'Proyecto Final'],
      'Programación' => ['Lógica', 'Estructuras de datos', 'Algoritmos', 'Debugging', 'Testing']
    }
    
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
      temas = temas_por_taller[taller.nombre] || ['Tema general']
      
      # Crear múltiples calificaciones por estudiante (hasta 5 evaluaciones)
      (1..3).each do |j|
        nota = notas_ejemplo[(i + j) % notas_ejemplo.length]
        comentario = comentarios[(i + j) % comentarios.length]
        nombre_eval = nombres_evaluaciones[(j - 1) % nombres_evaluaciones.length]
        tema = temas[(j - 1) % temas.length]
        
        Calificacion.create(
          estudiante_id: e.id,
          taller_id: taller.id,
          nota: nota,
          descripcion: comentario,
          nombre_evaluacion: nombre_eval,
          tema: tema
        )
        
        puts "✅ #{e.nombre} en #{taller.nombre} - #{nombre_eval} (#{tema}): #{nota}"
      end
    end

    puts "\n✅ Se crearon #{Calificacion.count} calificaciones de ejemplo"
  end
end
