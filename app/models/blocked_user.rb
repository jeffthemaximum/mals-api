# == Schema Information
#
# Table name: blocked_users
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_1_id  :bigint
#  user_2_id  :bigint
#
# Indexes
#
#  index_blocked_users_on_user_1_id  (user_1_id)
#  index_blocked_users_on_user_2_id  (user_2_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_1_id => users.id)
#  fk_rails_...  (user_2_id => users.id)
#

class BlockedUser < ApplicationRecord
end
