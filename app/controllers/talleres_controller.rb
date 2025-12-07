class TalleresController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  # Permite crear talleres a cualquier usuario autenticado; restringe edición/eliminación a admin
  before_action :require_admin!, only: [:edit, :update, :destroy]
  before_action :set_taller, only: [:show, :edit, :update, :destroy]

  # GET /talleres
  def index
    @talleres = Taller.all
  end

  # GET /talleres/:id
  def show
    @calificaciones = @taller.calificaciones.includes(:estudiante)
    
    # Obtener todos los estudiantes del taller:
    # 1. Los que tienen taller_id = @taller.id
    # 2. Los que tienen inscripciones APROBADAS en este taller
    # 3. Los que tienen calificaciones en este taller
    estudiantes_por_taller = Estudiante.where(taller_id: @taller.id)
    estudiantes_por_inscripcion = @taller.estudiantes_inscritos.where(inscripciones: { estado: 'aprobada' })
    estudiantes_por_calificaciones = Estudiante.joins(:calificaciones)
                                               .where(calificaciones: { taller_id: @taller.id })
                                               .distinct
    
    @estudiantes_taller = (estudiantes_por_taller.to_a + estudiantes_por_inscripcion.to_a + estudiantes_por_calificaciones.to_a).uniq { |e| e.id }
    
    # Cargar inscripciones pendientes para aprobación
    @inscripciones_pendientes = @taller.inscripciones.where(estado: 'pendiente').includes(:estudiante)
  end

  # GET /talleres/new
  def new
    @taller = Taller.new
  end

  # POST /talleres
  def create
    @taller = Taller.new(taller_params)
    if @taller.save
      redirect_to @taller, notice: "Taller creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /talleres/:id/edit
  def edit
  end

  # PATCH/PUT /talleres/:id
  def update
    if @taller.update(taller_params)
      redirect_to @taller, notice: "Taller actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /talleres/:id
  def destroy
    if @taller.destroy
      redirect_to talleres_path, notice: "Taller eliminado correctamente."
    else
      redirect_to @taller, alert: (@taller.errors.full_messages.presence || ["No se puede eliminar el taller porque tiene estudiantes inscritos."]).to_sentence
    end
  end


  private

  def set_taller
    @taller = Taller.find(params[:id])
  end

  def taller_params
    params.require(:taller).permit(:nombre, :descripcion, :fecha, :cupos, :numero_evaluaciones)
  end
end
