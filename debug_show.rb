#!/usr/bin/env rails runner

taller = Taller.find(1)
puts "=== DEBUG TALLER: #{taller.nombre} (id=#{taller.id}) ==="

puts "\n1. @estudiantes_taller calculation:"
puts "   a) estudiantes_inscritos con estado='aprobada':"
est1 = taller.estudiantes_inscritos.where(inscripciones: { estado: "aprobada" }).distinct.to_a
puts "      COUNT: #{est1.count}"
est1.each { |e| puts "      - #{e.nombre}" }

puts "\n   b) estudiantes_legacy (taller_id = #{taller.id}):"
est2 = Estudiante.where(taller_id: taller.id).to_a
puts "      COUNT: #{est2.count}"
est2.each { |e| puts "      - #{e.nombre}" }

puts "\n   c) estudiantes con calificaciones en este taller:"
est3 = Estudiante.joins(:calificaciones).where(calificaciones: { taller_id: taller.id }).distinct.to_a
puts "      COUNT: #{est3.count}"
est3.each { |e| puts "      - #{e.nombre}" }

puts "\n2. Final @estudiantes_taller array:"
final = (est1 + est2).uniq { |e| e.id }
final = (final + est3).uniq { |e| e.id }
puts "   COUNT: #{final.count}"
final.each { |e| puts "   - #{e.nombre}" }

puts "\n3. cupos_restantes: #{taller.cupos_restantes}"
puts "4. total_inscritos: #{taller.total_inscritos}"
puts "5. inscripciones aprobadas: #{taller.inscripciones.where(estado: "aprobada").count}"
