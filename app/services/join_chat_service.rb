class JoinChatService < ApplicationService
  def initialize(user_id, chat_id = nil)
    @user_id = user_id
    @chat_id = chat_id
  end

  def call
    @chat = nil
    @user = User.find @user_id
    unless @chat_id.nil?
      @chat = Chat.with_deleted.find_by_id @chat_id
    end

    unless @chat.nil?
      if !@chat.pending? || !@chat.deleted_at.nil?
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
        JoinChatJob.set(wait: 5.seconds).perform_later(@user.id, @chat.id)
      else
        recipient = other_chat.users.first
        other_chat.destroy!
        start_chat(recipient)
      end
    else
      other_chat = find_closest_within(5)

      @chat = Chat.new
      @chat.users << @user
      @chat.latitude, @chat.longitude = @user.latitude, @user.longitude

      if other_chat.present?
        recipient = other_chat.users.first

        @chat.users << recipient
        @chat.save!

        other_chat.destroy!
        start_chat(recipient)
      else
        @chat.save!
        JoinChatJob.set(wait: 5.seconds).perform_later(@user.id, @chat.id)
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

    def start_chat(recipient)
      unless @chat.users.exists? recipient.id
        @chat.users << recipient
      end

      unless @chat.users.exists? @user.id
        @chat.users << @user
      end

      @chat.start!
      @chat.save!

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
