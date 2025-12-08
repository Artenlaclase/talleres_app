FactoryBot.define do
  factory :taller do
    sequence(:nombre) { |n| "Taller #{n}" }
    descripcion { Faker::Lorem.paragraph }
    fecha { Faker::Date.forward(days: 30) }
    cupos { Faker::Number.between(from: 1, to: 30) }
    numero_evaluaciones { Faker::Number.between(from: 1, to: 5) }
  end
end
