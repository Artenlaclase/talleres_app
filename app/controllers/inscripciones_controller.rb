class InscripcionesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, only: %i[new create approve reject]
  before_action :set_taller, only: %i[new create]
  before_action :set_inscripcion, only: %i[approve reject]

  # GET /talleres/:taller_id/inscripciones/new
  def new
    # Obtener estudiantes que NO están inscritos en este taller
    @estudiantes_inscritos_ids = @taller.estudiantes.pluck(:id) + @taller.estudiantes_inscritos.pluck(:id)
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

    # Verificar que no esté ya inscrito en este taller
    if estudiante.taller_id == @taller.id || @taller.inscripciones.exists?(estudiante_id: estudiante.id)
      redirect_to @taller, alert: "#{estudiante.nombre} ya está inscrito en este taller"
      return
    end

    # Contar cuántos talleres tiene el estudiante
    talleres_actuales = []
    talleres_actuales << estudiante.taller_id if estudiante.taller_id.present?
    talleres_actuales += estudiante.talleres_inscritos.pluck(:id)
    talleres_actuales = talleres_actuales.uniq

    # Verificar si ya alcanzó el máximo de talleres por período
    if talleres_actuales.count >= estudiante.max_talleres_por_periodo
      redirect_to @taller, alert: "#{estudiante.nombre} ya ha alcanzado el máximo de #{estudiante.max_talleres_por_periodo} talleres por período"
      return
    end

    # Crear la inscripción en estado "aprobada" (el admin la añade directamente sin esperar aprobación)
    inscripcion = @taller.inscripciones.build(estudiante_id: estudiante.id, estado: 'aprobada')
    if inscripcion.save
      redirect_to @taller, notice: "✓ #{estudiante.nombre} ha sido inscrito en #{@taller.nombre} correctamente."
    else
      redirect_to @taller, alert: "Error al inscribir: #{inscripcion.errors.full_messages.join(', ')}"
    end
  end

  # PATCH/POST /inscripciones/:id/approve
  def approve
    if @inscripcion.update(estado: 'aprobada')
      redirect_to @inscripcion.taller, notice: "✓ Inscripción de #{@inscripcion.estudiante.nombre} aprobada"
    else
      redirect_to @inscripcion.taller, alert: "Error al aprobar inscripción"
    end
  end

  # PATCH/POST /inscripciones/:id/reject
  def reject
    if @inscripcion.update(estado: 'rechazada')
      redirect_to @inscripcion.taller, notice: "✗ Inscripción de #{@inscripcion.estudiante.nombre} rechazada"
    else
      redirect_to @inscripcion.taller, alert: "Error al rechazar inscripción"
    end
  end

  private

  def set_taller
    @taller = Taller.find(params[:taller_id])
  end

  def set_inscripcion
    @inscripcion = Inscripcion.find(params[:id])
  end
end
