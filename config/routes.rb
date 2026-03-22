Rails.application.routes.draw do
  # =======================================================
  # PANTALLA PRINCIPAL (El Login es la raíz de todo)
  # =======================================================
  root "sesiones#new"

  # =======================================================
  # PANTALLA INTERNA (Dashboard protegido)
  # =======================================================
  get "dashboard", to: "dashboard#index", as: :dashboard

  # =======================================================
  # RUTAS DE SEGURIDAD
  # =======================================================
  get    "login",  to: "sesiones#new"
  post   "login",  to: "sesiones#create"
  delete "logout", to: "sesiones#destroy"

  get "up" => "rails/health#show", as: :rails_health_check
end