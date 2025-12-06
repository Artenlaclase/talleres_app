class EstudiantesController < ApplicationController
  before_action :set_estudiante, only: %i[ show edit update destroy ]

  # GET /estudiantes or /estudiantes.json
  def index
    @estudiantes = Estudiante.all
  end

  # GET /estudiantes/1 or /estudiantes/1.json
  def show
  end

  # GET /estudiantes/new
  def new
    @estudiante = Estudiante.new
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
      @estudiante = Estudiante.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def estudiante_params
      params.expect(estudiante: [ :nombre, :curso, :taller_id ])
    end
end
