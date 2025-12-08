class ApplicationController < ActionController::Base
  # Protección CSRF
  protect_from_forgery with: :exception
  
  # Configurar parámetros seguros para Devise
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end

  private

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "Necesitas permisos de administrador para acceder."
    end
  end

  def require_authentication!
    redirect_to new_user_session_path, alert: "Debes iniciar sesión" unless user_signed_in?
  end
end
