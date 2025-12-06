class Api::V1::TalleresController < ApplicationController
  def index
    render json: Taller.all
  end

  def show
    @taller = Taller.find(params[:id])
    render json: @taller
  end
end
