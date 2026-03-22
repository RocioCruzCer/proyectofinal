class SesionesController < ApplicationController
  # ==========================================
  # ¡LA LÍNEA MÁGICA! 
  # Le dice al Guardia Global que te deje pasar sin estar logueada
  # SOLO para ver el formulario y para intentar entrar.
  # ==========================================
  skip_before_action :exigir_usuario_logueado, only: [:new, :create]

  # Muestra el formulario vacío (GET /login)
  def new
  end

  # Procesa los datos del formulario (POST /login)
  def create
    # 1. VALIDACIÓN DEL RECAPTCHA (Seguridad de Google)
    if verify_recaptcha
      # 2. BÚSQUEDA DEL USUARIO
      usuario = Usuario.find_by(strCorreo: params[:strCorreo])

      # 3. VALIDACIÓN DE CREDENCIALES (Bcrypt)
      if usuario && usuario.authenticate(params[:password])
        
        # 4. VALIDACIÓN DE ESTADO
        if usuario.idEstadoUsuario == 1
          # Generamos el Token JWT de seguridad
          payload = { usuario_id: usuario.id, exp: 24.hours.from_now.to_i }
          token = JWT.encode(payload, Rails.application.credentials.secret_key_base)

          # Guardamos sesión
          session[:jwt_token] = token
          session[:usuario_id] = usuario.id

          redirect_to root_path, notice: "¡Bienvenido, #{usuario.strNombreUsuario}!"
        else
          flash.now[:alert] = "Acceso denegado: Tu cuenta está inactiva."
          render :new, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = "Correo o contraseña incorrectos."
        render :new, status: :unprocessable_entity
      end
    else
      # Si el Captcha falla o no se marcó
      flash.now[:alert] = "Por favor, completa la verificación de que no eres un robot."
      render :new, status: :unprocessable_entity
    end
  end

  # Cierra la sesión (DELETE /logout)
  def destroy
    session[:jwt_token] = nil
    session[:usuario_id] = nil
    redirect_to login_path, notice: "Has cerrado sesión correctamente."
  end
end