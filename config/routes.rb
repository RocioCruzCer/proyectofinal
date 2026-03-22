Rails.application.routes.draw do
  root "sesiones#new"

  # =======================================================
  # PANTALLA INTERNA (Dashboard protegido)
  # =======================================================
  get "dashboard", to: "dashboard#index", as: :dashboard

  # =======================================================
  # RUTAS ESPECIALES DE PERMISOS (Deben ir ANTES de resources)
  # =======================================================
  # Movimos estas líneas aquí arriba para que tengan prioridad
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