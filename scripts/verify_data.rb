#!/usr/bin/env ruby

puts "\n" + "="*70
puts "VERIFICACIÓN DE DATOS RESTAURADOS".center(70)
puts "="*70 + "\n"

puts "\n📚 TALLERES (Total: #{Taller.count})".bold if defined?(String.colors)
puts "─" * 70
Taller.all.each do |t|
  inscritos = t.estudiantes.count
  disponibles = t.cupos - inscritos
  puts "  #{t.id}. #{t.nombre}"
  puts "     Cupos: #{inscritos}/#{t.cupos} (#{disponibles} disponibles)"
  puts "     Descripción: #{t.descripcion}"
  puts ""
end

puts "\n👥 ESTUDIANTES (Total: #{Estudiante.count})".bold if defined?(String.colors)
puts "─" * 70
Estudiante.all.each do |e|
  puts "  #{e.id}. #{e.nombre} (#{e.curso}) → #{e.taller.nombre}"
end

puts "\n" + "="*70
puts "RESUMEN POR TALLER".center(70)
puts "="*70 + "\n"
Taller.all.each do |t|
  puts "  • #{t.nombre}: #{t.estudiantes.count}/#{t.cupos} cupos"
end

puts "\n" + "="*70
puts "✅ VERIFICACIÓN COMPLETADA".center(70)
puts "="*70 + "\n"
