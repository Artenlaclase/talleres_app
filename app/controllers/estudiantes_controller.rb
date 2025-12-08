class EstudiantesController < ApplicationController
  before_action :authenticate_user!
  # Permite crear estudiantes a cualquier usuario autenticado; restringe edición/eliminación a admin
  before_action :require_admin!, only: %i[ edit update destroy ]
  before_action :set_estudiante, only: %i[ show edit update destroy request_inscription ]

  # GET /estudiantes or /estudiantes.json
  def index
    @talleres = Taller.all
    @cursos = Estudiante.distinct.pluck(:curso).compact
    
    # Obtener estudiantes sin cargar asociaciones que causen duplicados
    @estudiantes = Estudiante.all
    
    if params[:curso].present?
      @estudiantes = @estudiantes.where(curso: params[:curso])
    end
    
    if params[:taller_id].present?
      # Filtrar por estudiantes que tengan calificaciones en ese taller
      # Usar subquery para evitar JOINs que generen duplicados
      taller_id = params[:taller_id]
      @estudiantes = @estudiantes.where(id: Calificacion.where(taller_id: taller_id).distinct.pluck(:estudiante_id))
    end
    
    @estudiantes = @estudiantes.order(:nombre)
    
    # Solo pre-cargar taller (no cargar calificaciones aquí)
    @estudiantes = @estudiantes.includes(:taller)
  end

  # GET /estudiantes/1 or /estudiantes/1.json
  def show
    # Cargar talleres de 3 fuentes: taller_id principal, calificaciones e inscripciones APROBADAS
    talleres_set = Set.new
    talleres_set.add(@estudiante.taller_id) if @estudiante.taller_id.present?
    
    Calificacion.where(estudiante_id: @estudiante.id).distinct.pluck(:taller_id).each do |taller_id|
      talleres_set.add(taller_id)
    end
    
    Inscripcion.where(estudiante_id: @estudiante.id, estado: 'aprobada').distinct.pluck(:taller_id).each do |taller_id|
      talleres_set.add(taller_id)
    end
    
    @talleres_inscritos = Taller.where(id: talleres_set.to_a).order(:nombre)
    @talleres_faltantes = @estudiante.max_talleres_por_periodo - @talleres_inscritos.count
    
    # Cargar todas las inscripciones del estudiante (para mostrar pendientes)
    @inscripciones_pendientes = Inscripcion.where(estudiante_id: @estudiante.id, estado: 'pendiente').includes(:taller)
    
    # Cargar todos los talleres disponibles (excluyendo inscritos + pendientes)
    talleres_con_inscripcion = talleres_set.to_a + Inscripcion.where(estudiante_id: @estudiante.id, estado: 'pendiente').pluck(:taller_id)
    @talleres_disponibles = Taller.where.not(id: talleres_con_inscripcion.uniq).order(:nombre)
    
    # Cargar calificaciones agrupadas por taller
    @calificaciones_por_taller = {}
    @talleres_inscritos.each do |taller|
      @calificaciones_por_taller[taller.id] = Calificacion.where(
        estudiante_id: @estudiante.id,
        taller_id: taller.id
      ).order(nombre_evaluacion: :asc)
    end
  end

  # GET /estudiantes/new
  def new
    @estudiante = Estudiante.new(estudiante_params_from_query)
  end

  # GET /estudiantes/bulk_new
  def bulk_new
    @talleres = Taller.all
    @rows = 10
  end

  # GET /estudiantes/1/edit
  def edit
  end

  # POST /estudiantes or /estudiantes.json
  def create
    @estudiante = Estudiante.new(estudiante_params)

    respond_to do |format|
      if @estudiante.save
        format.html { redirect_to @estudiante, notice: "Estudiante was successfully created." }
        format.json { render :show, status: :created, location: @estudiante }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @estudiante.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /estudiantes/bulk_create
  def bulk_create
    entries = params.require(:estudiantes).permit!.to_h
    created = 0
    errors = []

    entries.values.each_with_index do |entry, idx|
      next if entry.values.all?(&:blank?)
      e = Estudiante.new(entry.slice("nombre", "curso", "taller_id"))
      unless e.save
        errors << "Fila #{idx + 1}: #{e.errors.full_messages.join(', ')}"
      else
        created += 1
      end
    end

    if errors.empty?
      redirect_to estudiantes_path, notice: "Se crearon #{created} estudiantes exitosamente."
    else
      flash[:alert] = "Algunas filas tienen errores: #{errors.join(' | ')}"
      @talleres = Taller.all
      @rows = entries.size.presence || 10
      render :bulk_new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /estudiantes/1 or /estudiantes/1.json
  def update
    respond_to do |format|
      if @estudiante.update(estudiante_params)
        format.html { redirect_to @estudiante, notice: "Estudiante was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @estudiante }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @estudiante.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estudiantes/1 or /estudiantes/1.json
  def destroy
    @estudiante.destroy!

    respond_to do |format|
      format.html { redirect_to estudiantes_path, notice: "Estudiante was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # POST /estudiantes/:id/request_inscription
  # Acción para que el estudiante solicite inscripción a un taller
  def request_inscription
    taller = Taller.find(params[:taller_id])

    # Verificar que no esté ya inscrito en este taller
    if @estudiante.taller_id == taller.id || taller.inscripciones.exists?(estudiante_id: @estudiante.id)
      redirect_to @estudiante, alert: "Ya estás inscrito en este taller"
      return
    end

    # Contar cuántos talleres tiene el estudiante
    talleres_actuales = []
    talleres_actuales << @estudiante.taller_id if @estudiante.taller_id.present?
    talleres_actuales += @estudiante.talleres_inscritos.where(inscripciones: { estado: 'aprobada' }).pluck(:id)
    talleres_actuales = talleres_actuales.uniq

    # Verificar si ya alcanzó el máximo de talleres por período
    if talleres_actuales.count >= @estudiante.max_talleres_por_periodo
      redirect_to @estudiante, alert: "Ya has alcanzado el máximo de #{@estudiante.max_talleres_por_periodo} talleres por período"
      return
    end

    # Verificar si hay cupos disponibles en el taller
    if taller.cupos_restantes <= 0
      redirect_to @estudiante, alert: "❌ El taller '#{taller.nombre}' está lleno. No hay cupos disponibles."
      return
    end

    # Crear la inscripción en estado "pendiente"
    inscripcion = taller.inscripciones.build(estudiante_id: @estudiante.id, estado: 'pendiente')
    if inscripcion.save
      redirect_to @estudiante, notice: "⏳ Solicitud de inscripción enviada para #{taller.nombre}. Pendiente de aprobación."
    else
      redirect_to @estudiante, alert: "Error al solicitar inscripción: #{inscripcion.errors.full_messages.join(', ')}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_estudiante
      @estudiante = Estudiante.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def estudiante_params
      params.require(:estudiante).permit(:nombre, :curso, :taller_id, :max_talleres_por_periodo)
    end

    def estudiante_params_from_query
      # Permite precargar taller_id desde query: ?estudiante[taller_id]=1
      if params[:estudiante].present?
        params.require(:estudiante).permit(:taller_id)
      else
        {}
      end
    end
end
