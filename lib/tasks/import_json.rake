# frozen_string_literal: true

require "json"

namespace :import do
  desc "Importar talleres desde JSON. Uso: rake import:talleres[PATH]"
  task :talleres, [:path] => :environment do |_t, args|
    path = args[:path] || "tmp/talleres.json"
    unless File.exist?(path)
      puts "Archivo no encontrado: #{path}"
      next
    end
    data = JSON.parse(File.read(path))
    count = 0
    data.each do |h|
      nombre = h["nombre"] || h[:nombre]
      next unless nombre
      taller = Taller.find_or_initialize_by(nombre: nombre)
      taller.descripcion = h["descripcion"] || h[:descripcion]
      fecha_str = h["fecha"] || h[:fecha]
      taller.fecha = fecha_str.to_s.strip.empty? ? (taller.fecha || Date.today) : Date.parse(fecha_str)
      cupos_val = h["cupos"] || h[:cupos]
      taller.cupos = (cupos_val || taller.cupos || 20).to_i
      if taller.save
        count += 1
      else
        puts "Error en '#{nombre}': #{taller.errors.full_messages.to_sentence}"
      end
    end
    puts "✅ Importados #{count} talleres desde #{path}"
  end

  desc "Importar estudiantes desde JSON. Uso: rake import:estudiantes[PATH]"
  task :estudiantes, [:path] => :environment do |_t, args|
    path = args[:path] || "tmp/estudiantes.json"
    unless File.exist?(path)
      puts "Archivo no encontrado: #{path}"
      next
    end
    data = JSON.parse(File.read(path))
    count = 0
    data.each do |h|
      nombre = h["nombre"] || h[:nombre]
      curso  = h["curso"]  || h[:curso]
      taller_id = h["taller_id"] || h[:taller_id]
      taller_nombre = (h.dig("taller", "nombre") || h.dig(:taller, :nombre) || h["taller_nombre"] || h[:taller_nombre])

      taller = nil
      if taller_id
        taller = Taller.find_by(id: taller_id)
      elsif taller_nombre
        taller = Taller.find_by(nombre: taller_nombre)
      end

      unless taller
        puts "Omitido '#{nombre}': taller no encontrado"
        next
      end

      e = Estudiante.find_or_initialize_by(nombre: nombre, curso: curso, taller_id: taller.id)
      if e.save
        count += 1
      else
        puts "Error en '#{nombre}': #{e.errors.full_messages.to_sentence}"
      end
    end
    puts "✅ Importados #{count} estudiantes desde #{path}"
  end
end
