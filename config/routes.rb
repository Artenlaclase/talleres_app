Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "devise/registrations" }

  namespace :api do
    namespace :v1 do
      resources :talleres, only: [:index, :show]
      resources :estudiantes, only: [:index, :show]
    end
  end

  resources :estudiantes
  resources :talleres
  get "pages/home"

  root "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check
end

