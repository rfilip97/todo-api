FactoryBot.define do
  factory :todo do
    title { "Buy something" }

    trait :completed do
      completed { true }
    end
  end
end
