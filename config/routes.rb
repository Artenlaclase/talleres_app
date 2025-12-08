Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "devise/registrations" }

  namespace :api do
    namespace :v1 do
      resources :talleres, only: [:index, :show]
      resources :estudiantes, only: [:index, :show]
    end
  end

  resources :estudiantes do
    collection do
      get :bulk_new
      post :bulk_create
    end
    member do
      post :request_inscription
    end
  end
  resources :talleres do
    resources :calificaciones, only: [:new, :create, :edit, :update, :destroy]
    resources :inscripciones, only: [:new, :create]
  end
  resources :inscripciones, only: [] do
    member do
      patch :approve
      patch :reject
      delete :destroy
    end
  end
  resources :calificaciones, only: [:index, :show]
  get "pages/home"

  root "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check
end

