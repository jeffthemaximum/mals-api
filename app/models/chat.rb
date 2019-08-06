# == Schema Information
#
# Table name: chats
#
#  id            :bigint           not null, primary key
#  aasm_state    :string(255)
#  deleted_at    :datetime
#  join_attempts :integer          default(0)
#  latitude      :decimal(10, 6)
#  longitude     :decimal(10, 6)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_chats_on_deleted_at              (deleted_at)
#  index_chats_on_latitude_and_longitude  (latitude,longitude)
#

class Chat < ApplicationRecord
  acts_as_paranoid
  include AASM

  has_many :chats_user
  has_many :messages
  has_many :notifications
  has_many :users, through: :chats_user

  validates :users, :length => { :minimum => 1, :maximum => 2 }

  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude

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

    event :abort do
      transitions from: :pending, to: :finished
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
