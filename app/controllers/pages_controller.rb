class PagesController < ApplicationController
  def home
    # Dashboard estadísticas
    @total_talleres = Taller.count
    @total_estudiantes = Estudiante.count
    @inscripciones_pendientes = Inscripcion.pendientes.count
    @inscripciones_aprobadas = Inscripcion.aprobadas.count
    
    # Para admins: información adicional
    if user_signed_in? && current_user.admin?
      @notificaciones_sin_leer = current_user.notifications.sin_leer.count
      @notificaciones_recientes = current_user.notifications.recientes
      @talleres_recientes = Taller.order(created_at: :desc).limit(5)
      @estudiantes_recientes = Estudiante.order(created_at: :desc).limit(5)
    else
      @notificaciones_sin_leer = 0
      @notificaciones_recientes = []
      @talleres_recientes = []
      @estudiantes_recientes = []
    end
  end
end
