class Api::V1::TalleresController < ApplicationController
  def index
    render json: Taller.all
  end
end
