class Chat < ApplicationRecord
  acts_as_paranoid
  include AASM

  has_many :chats_user
  has_many :messages
  has_many :notifications
  has_many :users, through: :chats_user

  validates :users, :length => { :minimum => 1, :maximum => 2 }

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

  def includes_user?(current_user_id)
    users.map { |user| user.id }.include? current_user_id
  end

  def recipient(current_user_id)
    if users.count == 2
      users.find { |user| user.id != current_user_id }
    end
  end
end
