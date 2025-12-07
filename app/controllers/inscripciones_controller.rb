class InscripcionesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_taller, only: %i[new create]

  # GET /talleres/:taller_id/inscripciones/new
  def new
    # Obtener estudiantes que NO están inscritos en este taller
    @estudiantes_inscritos_ids = @taller.estudiantes.pluck(:id)
    @estudiantes_disponibles = Estudiante.where.not(id: @estudiantes_inscritos_ids).order(:nombre)
  end

  # POST /talleres/:taller_id/inscripciones
  def create
    @taller = Taller.find(params[:taller_id])
    estudiante_id = params[:estudiante_id]

    if estudiante_id.blank?
      redirect_to @taller, alert: "Debes seleccionar un estudiante"
      return
    end

    estudiante = Estudiante.find(estudiante_id)

    # Verificar que no esté ya inscrito
    if estudiante.taller_id == @taller.id
      redirect_to @taller, alert: "#{estudiante.nombre} ya está inscrito en este taller"
      return
    end

    # Crear un nuevo registro de estudiante con el mismo nombre/curso pero diferente taller
    # O actualizar el taller_id si es el primer taller
    if estudiante.taller_id.nil?
      # Si no tiene taller asignado, asignarle este
      estudiante.update(taller_id: @taller.id)
      redirect_to @taller, notice: "#{estudiante.nombre} inscrito exitosamente"
    else
      # Si ya tiene taller, crear una calificación vacía para registrar la relación
      # En realidad, la relación se crea automáticamente cuando se agrega una calificación
      redirect_to new_taller_calificacione_path(@taller), notice: "Ahora puedes agregar calificaciones para #{estudiante.nombre}"
    end
  end

  private

  def set_taller
    @taller = Taller.find(params[:taller_id])
  end
end
