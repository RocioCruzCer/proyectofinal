Rails.application.routes.draw do
  # =======================================================
  # MÓDULO DE SEGURIDAD (Fase 2: Login y Autenticación)
  # =======================================================
  root "sesiones#new"              # La raíz del sitio es el Login
  get    "login",  to: "sesiones#new"
  post   "login",  to: "sesiones#create"
  delete "logout", to: "sesiones#destroy"

  # =======================================================
  # MÓDULO DE ADMINISTRACIÓN (Fases futuras: CRUDs)
  # =======================================================
  # Aquí irán: resources :usuarios, resources :perfiles, etc.


  # =======================================================
  # RUTAS DEL SISTEMA (Rails default)
  # =======================================================
  get "up" => "rails/health#show", as: :rails_health_check
end