class CalificacionesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_calificacion, only: [:show, :edit, :update, :destroy]

  def index
    @calificaciones = Calificacion.all.includes(:estudiante, :taller)
    
    @calificaciones = @calificaciones.where(estudiante_id: params[:estudiante_id]) if params[:estudiante_id].present?
    @calificaciones = @calificaciones.where(taller_id: params[:taller_id]) if params[:taller_id].present?
    
    @estudiantes = Estudiante.all.order(:nombre)
    @talleres = Taller.all.order(:nombre)
    
    # Calcular promedio por taller
    @promedios_por_taller = {}
    @talleres.each do |taller|
      calificaciones_taller = Calificacion.where(taller_id: taller.id)
      if calificaciones_taller.any?
        promedio = calificaciones_taller.average(:nota).round(1)
        @promedios_por_taller[taller.id] = promedio
      end
    end
  end

  def show
  end

  def new
    @calificacion = Calificacion.new
    @estudiantes = Estudiante.all.order(:nombre)
    @talleres = Taller.all.order(:nombre)
  end

  def create
    @calificacion = Calificacion.new(calificacion_params)
    
    if @calificacion.save
      redirect_to @calificacion, notice: "Calificación creada exitosamente."
    else
      @estudiantes = Estudiante.all.order(:nombre)
      @talleres = Taller.all.order(:nombre)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @estudiantes = Estudiante.all.order(:nombre)
    @talleres = Taller.all.order(:nombre)
  end

  def update
    if @calificacion.update(calificacion_params)
      redirect_to @calificacion, notice: "Calificación actualizada exitosamente."
    else
      @estudiantes = Estudiante.all.order(:nombre)
      @talleres = Taller.all.order(:nombre)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @calificacion.destroy
    redirect_to calificaciones_url, notice: "Calificación eliminada exitosamente."
  end

  private

  def set_calificacion
    @calificacion = Calificacion.find(params[:id])
  end

  def authorize_admin!
    redirect_to root_path, alert: "No autorizado" unless current_user.admin?
  end

  def calificacion_params
    params.require(:calificacion).permit(:estudiante_id, :taller_id, :nota, :descripcion)
  end
end
