FactoryBot.define do
  factory :inscripcion do
    estudiante { association :estudiante }
    taller { association :taller }
    estado { :pendiente }

    trait :aprobada do
      estado { :aprobada }
    end

    trait :rechazada do
      estado { :rechazada }
    end
  end
end
