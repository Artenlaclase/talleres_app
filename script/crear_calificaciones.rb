#!/usr/bin/env ruby

# Script para crear calificaciones de ejemplo
estudiantes = Estudiante.all
talleres = Taller.all

notas_ejemplo = [85, 92, 78, 88, 95, 72, 88, 90, 85, 78, 88, 92, 80, 85, 90]
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
  
  puts "Calificación creada: #{e.nombre} en #{taller.nombre} - Nota: #{nota}"
end

puts "\n✅ Se crearon #{Calificacion.count} calificaciones de ejemplo"
