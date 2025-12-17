class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:show, :mark_as_read, :destroy]

  # GET /notifications
  def index
    @notifications = current_user.notifications.por_fecha
    @unread_count = current_user.notifications.sin_leer.count
    
    # Marcar notificaciones como leídas si acceden al índice
    current_user.notifications.sin_leer.update_all(read_at: Time.current)
  end

  # GET /notifications/:id
  def show
    @notification.mark_as_read unless @notification.read?
  end

  # PATCH /notifications/:id/mark_as_read
  def mark_as_read
    @notification.mark_as_read
    
    if request.turbo_stream?
      render turbo_stream: turbo_stream.replace(@notification, partial: "notification", locals: { notification: @notification })
    else
      redirect_to notifications_path, notice: "Notificación marcada como leída"
    end
  end

  # DELETE /notifications/:id
  def destroy
    @notification.destroy
    
    if request.turbo_stream?
      render turbo_stream: turbo_stream.remove(@notification)
    else
      redirect_to notifications_path, notice: "Notificación eliminada"
    end
  end

  # GET /notifications/unread_count
  def unread_count
    count = current_user.notifications.sin_leer.count
    render json: { count: count }
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
    authorize_notification!
  end

  def authorize_notification!
    redirect_to root_path, alert: "No autorizado" unless @notification.user == current_user
  end
end
