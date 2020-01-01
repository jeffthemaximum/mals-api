# == Schema Information
#
# Table name: users
#
#  id          :bigint           not null, primary key
#  avatar_file :text(65535)
#  avatar_url  :string(255)
#  is_admin    :boolean          default(FALSE)
#  latitude    :decimal(10, 6)
#  longitude   :decimal(10, 6)
#  name        :string(191)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_users_on_latitude_and_longitude  (latitude,longitude)
#  index_users_on_name                    (name) UNIQUE
#

class User < ApplicationRecord
  include AuthUtil::Jwt

  before_validation :set_name_or_fake, :set_avatar

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :chats_user
  has_many :chats, through: :chats_user
  has_many :devices_user
  has_many :devices, through: :devices_user
  has_many :messages
  has_many :notifications

  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  def block!(user_id)
    user_to_block = User.find(user_id)
    bu = BlockedUser.new(user_1_id: self.id, user_2_id: user_to_block.id)
    bu.save!
  end

  def find_blocks
    blocked_users = []

    has_blocked = BlockedUser.where({ user_1_id: self.id })
    if has_blocked.length > 0
      users = has_blocked.map{ |bu| User.find(bu.user_2_id) }
      (blocked_users << users).flatten!
    end


    has_been_blocked = BlockedUser.where({ user_2_id: self.id })
    if has_been_blocked.length > 0
      users = has_been_blocked.map{ |bu| User.find(bu.user_1_id) }
      (blocked_users << users).flatten!
    end

    return blocked_users
  end

  def hide!(user_id)
    user_to_hide = User.find(user_id)
    bu = BlockedUser.new(user_1_id: self.id, user_2_id: user_to_hide.id)
    bu.save!
    bu.hidden!
    HiddenUsersJob.set(wait: 5.minute).perform_later(bu.id)
  end

  def most_recent_recipient_chat(recipient_id)
    # TODO do this without looping over all chats
    all_chats = self
      .chats
      .includes(:messages)
      .order('chats.created_at DESC')
      .order('messages.created_at DESC')
      .where.not(aasm_state: Chat.aasm.initial_state)

    for chat in all_chats do
      recipient = chat.recipient(self.id)

      if recipient
        if recipient.id == recipient_id
          return chat
        end
      end
    end

    return nil
  end

  def update_avatar(name = self.name)
    unless Rails.env.test?
      avatar_data = AvatarCreatorService.call(name)
      self.avatar_url = avatar_data[:url]
      if (avatar_data[:svg])
        self.avatar_file = avatar_data[:svg]
      end
    end
  end

  def update_avatar!
    self.update_avatar
    self.save!
  end

  private
    def generate_fake_name
      fake_name = Faker::Name.unique.first_name
      existing_user = User.find_by name: fake_name
      while (existing_user.present?)
        number = Faker::Number.number(1)
        fake_name = "#{fake_name}#{number}"
        existing_user = User.find_by name: fake_name
      end
      return fake_name
    end

    def set_avatar
      unless(self.avatar_url.present?)
        self.update_avatar
      end
    end

    def set_name_or_fake
      unless(self.name.present?)
        self.name = generate_fake_name
      end
    end
end
