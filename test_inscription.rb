#!/usr/bin/env rails runner

taller = Taller.find(1)
estudiante = Estudiante.find(11)

puts "Estudiante: #{estudiante.nombre}"
puts "Taller: #{taller.nombre}"
puts "Inscripciones pendientes antes: #{Inscripcion.where(estudiante_id: 11, estado: 'pendiente').count}"

# Simular la acción request_inscription
inscripcion = taller.inscripciones.build(estudiante_id: 11, estado: 'pendiente')
if inscripcion.save
  puts "✓ Inscripción creada correctamente"
  puts "Inscripciones pendientes después: #{Inscripcion.where(estudiante_id: 11, estado: 'pendiente').count}"
else
  puts "✗ Error: #{inscripcion.errors.full_messages.join(', ')}"
end
