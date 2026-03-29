class SesionesController < ApplicationController

  # Le dice al Guardia Global que te deje pasar sin estar logueada
  skip_before_action :exigir_usuario_logueado, only: [:new, :create]

  # Si YA estás logueada, te saca del login y te manda al Dashboard.
  before_action :redirigir_si_logueado, only: [:new, :create]

  # Muestra el formulario vacío (GET /login)
  def new
  end

  # Procesa los datos del formulario (POST /login)
  def create
    # 1. VALIDACIÓN DEL RECAPTCHA (Seguridad de Google)
    if verify_recaptcha
      # 2. BÚSQUEDA DEL USUARIO (Ahora por Nombre de Usuario)
      usuario = Usuario.find_by(strNombreUsuario: params[:strNombreUsuario])

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

          # ==========================================
          # CAMBIO 1: Si inicia bien, se va al Dashboard
          # ==========================================
          redirect_to dashboard_path, notice: "¡Bienvenido, #{usuario.strNombreUsuario}!"
        else
          flash.now[:alert] = "Acceso denegado: Tu cuenta está inactiva."
          render :new, status: :unprocessable_entity
        end
      else
        # Actualizamos el mensaje de error para que no diga "Correo"
        flash.now[:alert] = "Usuario o contraseña incorrectos."
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
    
    # ==========================================
    # CAMBIO 2: Al salir, te manda a la raíz (que ahora es el login)
    # ==========================================
    redirect_to root_path, notice: "Has cerrado sesión correctamente."
  end

  private

  # Método que hace el rebote si ya tienes sesión
  def redirigir_si_logueado
    if usuario_logueado?
      # ==========================================
      # CAMBIO 3: Aquí rompemos el bucle enviándote al Dashboard
      # ==========================================
      redirect_to dashboard_path
    end
  end
end