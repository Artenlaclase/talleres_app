Rails.application.routes.draw do
  get "talleres/index"
  get "talleres/show"
  get "talleres/new"
  get "talleres/create"
  get "talleres/edit"
  get "talleres/update"
  get "talleres/destroy"
  get "pages/home"
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"
end
