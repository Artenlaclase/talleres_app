Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "estudiantes/index"
      get "estudiantes/show"
      get "talleres/index"
    end
  end
  devise_for :users
  resources :estudiantes
  get "pages/home"

  root "pages#home"

  resources :talleres

  get "up" => "rails/health#show", as: :rails_health_check
end

