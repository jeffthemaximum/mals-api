class Chat < ApplicationRecord
  include AASM

  has_many :chats_user
  has_many :users, through: :chats_user

  aasm do
    state :pending, initial: true
    state :active
    state :finished

    event :start do
      transitions from: :pending, to: :active, guard: :can_start?
    end

    event :finish do
      transitions from: :active, to: :finished
    end
  end

  def can_start?
    users.count == 2
  end
end
