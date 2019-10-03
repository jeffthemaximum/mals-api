# == Schema Information
#
# Table name: blocked_users
#
#  id           :bigint           not null, primary key
#  blocked_type :integer          default("default")
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_1_id    :bigint
#  user_2_id    :bigint
#
# Indexes
#
#  index_blocked_users_on_blocked_type  (blocked_type)
#  index_blocked_users_on_deleted_at    (deleted_at)
#  index_blocked_users_on_user_1_id     (user_1_id)
#  index_blocked_users_on_user_2_id     (user_2_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_1_id => users.id)
#  fk_rails_...  (user_2_id => users.id)
#

require 'rails_helper'

RSpec.describe BlockedUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
