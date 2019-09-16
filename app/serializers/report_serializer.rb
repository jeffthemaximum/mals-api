# == Schema Information
#
# Table name: reports
#
#  id         :bigint           not null, primary key
#  content    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chat_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_reports_on_chat_id  (chat_id)
#  index_reports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#  fk_rails_...  (user_id => users.id)
#

class ReportSerializer < ActiveModel::Serializer
  attributes :id
end
