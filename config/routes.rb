Rails.application.routes.draw do
  root "sesiones#new"

  # =======================================================
  # PANTALLA INTERNA (Dashboard protegido)
  # =======================================================
  get "dashboard", to: "dashboard#index", as: :dashboard

  # =======================================================
  # RUTAS ESTÁTICAS (Principal 1 y 2)
  # =======================================================
  get 'principal1_1', to: 'principales#principal1_1', as: :principal1_1
  get 'principal1_2', to: 'principales#principal1_2', as: :principal1_2
  get 'principal2_1', to: 'principales#principal2_1', as: :principal2_1
  get 'principal2_2', to: 'principales#principal2_2', as: :principal2_2

  # =======================================================
  # RUTAS ESPECIALES DE PERMISOS (Deben ir ANTES de resources)
  # =======================================================
  get  "permisos/buscar", to: "permisos#buscar"
  post "permisos/guardar_matriz", to: "permisos#guardar_matriz"

  # =======================================================
  # MÓDULOS OPERATIVOS (CRUDs)
  # =======================================================
  resources :perfiles
  resources :modulos
  resources :permisos
  resources :usuarios

  # =======================================================
  # RUTAS DE SEGURIDAD (Sesiones)
  # =======================================================
  get    "login",  to: "sesiones#new"
  post   "login",  to: "sesiones#create"
  delete "logout", to: "sesiones#destroy"

  get "up" => "rails/health#show", as: :rails_health_check
end