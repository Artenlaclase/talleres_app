FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "Password123!" }
    password_confirmation { "Password123!" }
    role { :usuario }

    trait :admin do
      role { :admin }
    end

    trait :locked do
      locked_at { Time.current }
    end
  end
end
