# frozen_string_literal: true

require "json"

namespace :export do
  desc "Exportar talleres a JSON. Uso: rake export:talleres[PATH] (por defecto tmp/talleres.json)"
  task :talleres, [:path] => :environment do |_t, args|
    path = args[:path] || "tmp/talleres.json"
    Dir.mkdir("tmp") unless Dir.exist?("tmp")
    arr = Taller.all.map do |t|
      {
        id: t.id,
        nombre: t.nombre,
        descripcion: t.descripcion,
        fecha: t.fecha&.to_s,
        cupos: t.cupos,
        inscritos: t.estudiantes.count
      }
    end
    File.write(path, JSON.pretty_generate(arr))
    puts "📤 Exportados #{arr.size} talleres a #{path}"
  end

  desc "Exportar estudiantes a JSON. Uso: rake export:estudiantes[PATH] (por defecto tmp/estudiantes.json)"
  task :estudiantes, [:path] => :environment do |_t, args|
    path = args[:path] || "tmp/estudiantes.json"
    Dir.mkdir("tmp") unless Dir.exist?("tmp")
    arr = Estudiante.all.includes(:taller).map do |e|
      {
        id: e.id,
        nombre: e.nombre,
        curso: e.curso,
        taller_id: e.taller_id,
        taller: {
          id: e.taller_id,
          nombre: e.taller&.nombre
        }
      }
    end
    File.write(path, JSON.pretty_generate(arr))
    puts "📤 Exportados #{arr.size} estudiantes a #{path}"
  end
end
