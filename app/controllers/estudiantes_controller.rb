class EstudiantesController < ApplicationController
  before_action :authenticate_user!
  # Permite crear estudiantes a cualquier usuario autenticado; restringe edición/eliminación a admin
  before_action :require_admin!, only: %i[ edit update destroy ]
  before_action :set_estudiante, only: %i[ show edit update destroy ]

  # GET /estudiantes or /estudiantes.json
  def index
    @talleres = Taller.all
    @cursos = Estudiante.distinct.pluck(:curso).compact
    @estudiantes = Estudiante.all
    if params[:curso].present?
      @estudiantes = @estudiantes.where(curso: params[:curso])
    end
    if params[:taller_id].present?
      @estudiantes = @estudiantes.where(taller_id: params[:taller_id])
    end
  end

  # GET /estudiantes/1 or /estudiantes/1.json
  def show
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
