FactoryBot.define do
  factory :chat do
    before(:create) { |chat| chat.users << FactoryBot.build(:user) }
  end

  factory :started_chat, class: Chat do
    before(:create) { |chat|
      chat.users << FactoryBot.build(:user)
      chat.users << FactoryBot.build(:user)
    }
    after(:create) { |chat|
      chat.start!
    }
  end
end
