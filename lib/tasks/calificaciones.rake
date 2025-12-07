namespace :calificaciones do
  desc "Crear calificaciones de ejemplo"
  task crear_ejemplo: :environment do
    estudiantes = Estudiante.all
    
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
      nota = notas_ejemplo[i % notas_ejemplo.length]
      comentario = comentarios[i % comentarios.length]
      
      calificacion = Calificacion.find_or_create_by(
        estudiante_id: e.id,
        taller_id: taller.id
      ) do |c|
        c.nota = nota
        c.descripcion = comentario
      end
      
      puts "✅ Calificación: #{e.nombre} en #{taller.nombre} - Nota: #{nota}"
    end

    puts "\n✅ Se crearon #{Calificacion.count} calificaciones de ejemplo"
  end
end
