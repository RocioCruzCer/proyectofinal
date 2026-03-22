Rails.application.routes.draw do

  root "sesiones#new"

  # =======================================================
  # PANTALLA INTERNA (Dashboard protegido)
  # =======================================================
  get "dashboard", to: "dashboard#index", as: :dashboard

  # =======================================================
  # MÓDULOS OPERATIVOS (CRUDs)
  # =======================================================
  resources :perfiles
  resources :modulos
  # =======================================================
  # RUTAS DE SEGURIDAD
  # =======================================================
  get    "login",  to: "sesiones#new"
  post   "login",  to: "sesiones#create"
  delete "logout", to: "sesiones#destroy"

  get "up" => "rails/health#show", as: :rails_health_check
end