Rails.application.routes.draw do
  devise_for :users
  resources :estudiantes
  get "pages/home"

  root "pages#home"

  resources :talleres

  get "up" => "rails/health#show", as: :rails_health_check
end

