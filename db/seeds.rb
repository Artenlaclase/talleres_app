# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Crear usuario admin
admin = User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = "admin"
end

# Crear algunos talleres de ejemplo
Taller.find_or_create_by!(nombre: "Introducción a Rails") do |taller|
  taller.descripcion = "Aprende los fundamentos de Ruby on Rails"
  taller.fecha = Date.today + 7.days
  taller.cupos = 20
end

Taller.find_or_create_by!(nombre: "Tailwind CSS Avanzado") do |taller|
  taller.descripcion = "Domina Tailwind CSS y crea interfaces modernas"
  taller.fecha = Date.today + 14.days
  taller.cupos = 25
end

Taller.find_or_create_by!(nombre: "APIs REST con Rails") do |taller|
  taller.descripcion = "Construye APIs REST profesionales"
  taller.fecha = Date.today + 21.days
  taller.cupos = 15
end
# Sample Estudiantes linked to existing Talleres
begin
  rob = Taller.find_by(nombre: "Robótica básica") || Taller.first
  web = Taller.find_by(nombre: "Web con Rails") || Taller.second
  ia  = Taller.find_by(nombre: "Introducción a IA") || Taller.third

  Estudiante.find_or_create_by!(nombre: "Ana Pérez", curso: "2°A", taller: rob)
  Estudiante.find_or_create_by!(nombre: "Luis Gómez", curso: "3°B", taller: web)
  Estudiante.find_or_create_by!(nombre: "María López", curso: "1°C", taller: ia)
rescue => e
  puts "Seed warning: #{e.message}"
end

puts "✅ Seeds creados exitosamente"
puts "Usuario admin: admin@example.com / password123"
