class HiddenUsersJob < ApplicationJob
  def perform(blocked_users_id)
    bu = BlockedUser.hidden.find_by(id: blocked_users_id)
    unless bu.nil?
      bu.destroy!
    end
  end
end
