Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "devise/registrations" }

  # WebSocket para Action Cable
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :talleres, only: [:index, :show]
      resources :estudiantes, only: [:index, :show]
    end
  end

  # Notificaciones
  resources :notifications, only: [:index, :show, :destroy] do
    member do
      patch :mark_as_read
    end
    collection do
      get :unread_count
      patch :mark_all_as_read
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
  resources :inscripciones, only: [:index] do
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


