FactoryBot.define do
  factory :calificacion do
    estudiante { association :estudiante }
    taller { association :taller }
    sequence(:nombre_evaluacion) { |n| "Evaluación #{n}" }
    nota { Faker::Number.between(from: 10, to: 70).to_f / 10.0 }

    trait :aprobada do
      nota { Faker::Number.between(from: 55, to: 70).to_f / 10.0 }
    end

    trait :reprobada do
      nota { Faker::Number.between(from: 10, to: 54).to_f / 10.0 }
    end
  end
end
