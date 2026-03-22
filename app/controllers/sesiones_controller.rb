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

  # ==========================================
  # RUTA TEMPORAL (Borrar después de usar)
  # ==========================================
  def crear_admin
    begin
      usuario = Usuario.find_or_initialize_by(strCorreo: "admin@sistema.com")
      usuario.strNombreUsuario = "Admin"
      usuario.strNumeroCelular = "5551234567"
      usuario.idPerfil = 1
      usuario.idEstadoUsuario = 1
      usuario.password = "Password123!"

      # validate: false fuerza a que se guarde ignorando validaciones de Rails 
      # (aunque no ignora las de Base de Datos)
      if usuario.save(validate: false)
        render plain: "¡ÉXITO! El administrador ya existe en Render. Ya puedes ir a /login"
      else
        render plain: "No se pudo crear: #{usuario.errors.full_messages}"
      end
    rescue => e
      # Si la base de datos lo bloquea por llaves foráneas, nos lo dirá aquí
      render plain: "ERROR CRÍTICO EN BASE DE DATOS: #{e.message}"
    end
  end
end
