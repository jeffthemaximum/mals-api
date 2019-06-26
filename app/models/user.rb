# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  include AuthUtil::Jwt

  before_validation :set_name_or_fake

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :chats_user
  has_many :chats, through: :chats_user

  private

    def set_name_or_fake
      unless(self.name.present?)
        self.name = generate_fake_name
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
