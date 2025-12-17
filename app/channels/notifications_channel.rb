class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when user unsubscribes
  end

  def mark_as_read(data)
    notification = Notification.find(data['notification_id'])
    if notification.user == current_user
      notification.mark_as_read
      broadcast_to_user("notification_read", { notification_id: notification.id })
    end
  end

  private

  def broadcast_to_user(action, data)
    ActionCable.server.broadcast("notifications:#{current_user.id}", { action: action, data: data })
  end
end
