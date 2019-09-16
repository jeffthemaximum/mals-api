FactoryBot.define do
  factory :device do
    unique_id { Faker::String.random }
  end
end
