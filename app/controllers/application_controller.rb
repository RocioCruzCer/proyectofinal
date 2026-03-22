class ApplicationController < ActionController::Base
  # 1. Le decimos a Rails que ejecute esta función ANTES de cualquier acción en toda la app
  before_action :exigir_usuario_logueado

  # 2. Hacemos que estos métodos estén disponibles también en las vistas (HTML)
  helper_method :usuario_actual, :usuario_logueado?

  private

  # Busca al usuario en la base de datos usando el ID guardado en la sesión
  def usuario_actual
    if session[:usuario_id]
      @usuario_actual ||= Usuario.find_by(id: session[:usuario_id])
    end
  end

  # Devuelve 'true' si hay un usuario logueado, 'false' si no
  def usuario_logueado?
    !!usuario_actual
  end

  # El guardia de seguridad: Si no estás logueado, te manda al login
  def exigir_usuario_logueado
    unless usuario_logueado?
      redirect_to login_path, alert: "Debes iniciar sesión para acceder a esta sección."
    end
  end
end