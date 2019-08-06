class JoinChatService < ApplicationService
  def initialize(user, chat = nil)
    @user = user
    @chat = chat
  end

  def call
    unless @chat.nil?
      unless @chat.pending?
        return
      end

      join_attempts_to_within_map = {
        0 => 50,
        1 => 200,
        2 => 500,
        3 => 2000
      }

      within = join_attempts_to_within_map[@chat.join_attempts]

      if within.nil?
        other_chat = find_closest
      else
        other_chat = find_closest_within(within)
      end

      if other_chat.nil?
        @chat.join_attempts += 1
        @chat.save!
        JoinChatJob.set(wait: 5.seconds).perform_later(@user, @chat)
      else
        recipient = other_chat.users.first
        other_chat.destroy!
        start_chat(recipient, other_chat)
      end
    else
      @chat = find_closest_within(5)

      if @chat.present?
        @chat.users << @user
        recipient = @chat.recipient(@user.id)
        other_chat = recipient.chats.last
        start_chat(recipient, other_chat)
      else
        @chat = Chat.new
        @chat.users << @user
        @chat.latitude, @chat.longitude = @user.latitude, @user.longitude
        @chat.save!
        JoinChatJob.set(wait: 5.seconds).perform_later(@user, @chat)
      end
    end
  end

  private
    def find_closest_within(n_miles)
      Chat.includes(:users).where.not( :users => { :id => @user.id } ).within( n_miles, :origin => [@user.latitude, @user.longitude] ).find_by(aasm_state: Chat.aasm.initial_state)
    end

    def find_closest
      Chat.includes(:users).where.not( :users => { :id => @user.id } ).by_distance(:origin => [@user.latitude, @user.longitude]).find_by(aasm_state: Chat.aasm.initial_state)
    end

    def start_chat(recipient, other_chat)
      unless @chat.users.exists? recipient.id
        @chat.users << recipient
      end

      unless @chat.users.exists? @user.id
        @chat.users << @user
      end

      started = false
      if @chat.may_start?
        started = true
        @chat.start!
      end

      @chat.save!

      if (started == true)
        serialized_data = ActiveModelSerializers::Adapter::Json.new(
          ChatSerializer.new(@chat)
        ).serializable_hash

        ActionCable.server.broadcast(
          "current_user_#{@user.id}",
          serialized_data
        )

        ActionCable.server.broadcast(
          "current_user_#{recipient.id}",
          serialized_data
        )
      end
    end
end
