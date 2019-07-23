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
  has_many :messages
  has_many :notifications

  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  private
    def set_name_or_fake
      unless(self.name.present?)
        self.name = generate_fake_name
      end
    end

    def set_avatar
      unless(self.avatar_url.present?)
        unless Rails.env.test?
          avatar_data = AvatarCreatorService.call(self)
          self.avatar_url = avatar_data[:url]
          if (avatar_data[:svg])
            self.avatar_file = avatar_data[:svg]
          end
        end
      end
    end

    def generate_fake_name
      fake_name = Faker::Name.unique.first_name
      existing_user = User.find_by name: fake_name
      while (existing_user.present?)
        number = Faker::Number.number(4)
        fake_name = "#{fake_name}#{number}"
        existing_user = User.find_by name: fake_name
      end
      return fake_name
    end
end
