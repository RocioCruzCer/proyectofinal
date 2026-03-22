class SesionesController < ApplicationController
  # Muestra el formulario vacío (GET /login)
  def new
  end

  # Procesa los datos del formulario (POST /login)
  def create
    # Buscamos al usuario por su columna exacta en la BD
    usuario = Usuario.find_by(strCorreo: params[:strCorreo])

    # PASO 1 y 2: Validar si existe y si la contraseña coincide (bcrypt)
    if usuario && usuario.authenticate(params[:password])
      
      # PASO 3: Validar que esté activo (Asumimos idEstadoUsuario: 1 = Activo)
      if usuario.idEstadoUsuario == 1
        
        # Generamos el Token JWT de seguridad
        payload = { usuario_id: usuario.id, exp: 24.hours.from_now.to_i }
        token = JWT.encode(payload, Rails.application.credentials.secret_key_base)

        # Guardamos el token y el usuario en la sesión del navegador
        session[:jwt_token] = token
        session[:usuario_id] = usuario.id

        # Redirigimos con mensaje de éxito (Por ahora al root, luego al Dashboard)
        redirect_to root_path, notice: "¡Bienvenido, #{usuario.strNombreUsuario}!"
      else
        # Falla: Usuario inactivo
        flash.now[:alert] = "Acceso denegado: Tu cuenta está inactiva."
        render :new, status: :unprocessable_entity
      end
    else
      # Falla: Credenciales incorrectas
      flash.now[:alert] = "Correo o contraseña incorrectos."
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