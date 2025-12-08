FactoryBot.define do
  factory :estudiante do
    sequence(:nombre) { |n| "Estudiante #{n}" }
    curso { ["1°", "2°", "3°", "4°"].sample }
    association :taller, factory: :taller
    user { association :user }
    max_talleres_por_periodo { 3 }
  end
end
