class Api::V1::EstudiantesController < ApplicationController
  def index
    render json: Estudiante.all
  end

  def show
    @estudiante = Estudiante.find(params[:id])
    render json: @estudiante
  end
end
