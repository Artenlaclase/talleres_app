class TalleresController < ApplicationController
  before_action :set_taller, only: [:show, :edit, :update, :destroy]

  # GET /talleres
  def index
    @talleres = Taller.all
  end

  # GET /talleres/:id
  def show
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
    @taller.destroy
    redirect_to talleres_path, notice: "Taller eliminado correctamente."
  end


  private

  def set_taller
    @taller = Taller.find(params[:id])
  end

  def taller_params
    params.require(:taller).permit(:nombre, :descripcion, :fecha, :cupos)
  end
end
