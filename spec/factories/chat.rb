FactoryBot.define do
  factory :chat do
    before(:create) { |chat| chat.users << FactoryBot.build(:user) }
  end
end
