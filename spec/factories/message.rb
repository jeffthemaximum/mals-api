FactoryBot.define do
  factory :message do
    text { Faker::String.random }

    association :chat, factory: :chat
    association :user, factory: :user
  end
end
