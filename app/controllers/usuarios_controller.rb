class UsuariosController < ApplicationController
  include Rails.application.routes.url_helpers
  
  # Filtro de seguridad: Verifica permisos específicos
  before_action -> { validar_acceso("usuario", :bitConsulta) }, only: [:index]
  before_action -> { validar_acceso("usuario", :bitAgregar) }, only: [:create]
  before_action -> { validar_acceso("usuario", :bitEditar) }, only: [:update]
  before_action -> { validar_acceso("usuario", :bitEliminar) }, only: [:destroy]

  def index
    respond_to do |format|
      format.html
      format.json do
        page = (params[:page] || 1).to_i
        per_page = 5
        
        # 1. Iniciamos la consulta base (sin las fotos para evitar el error 500 al contar)
        query = Usuario.all
        
        # 2. Aplicamos filtros dinámicos si vienen en la URL
        if params[:usuario].present?
          # En PostgreSQL, las columnas con mayúsculas DEBEN ir entre comillas dobles ("")
          # Usamos ILIKE para que la búsqueda ignore mayúsculas/minúsculas de forma nativa
          query = query.where('"strNombreUsuario" ILIKE ?', "%#{params[:usuario]}%")
        end
        
        if params[:perfil].present?
          query = query.where(idPerfil: params[:perfil])
        end
        
        if params[:estado].present?
          query = query.where(idEstadoUsuario: params[:estado])
        end

        # 3. Calculamos totales (ahora .count funcionará perfecto)
        total_registros = query.count
        total_paginas = total_registros > 0 ? (total_registros.to_f / per_page).ceil : 1
        
        # 4. Paginamos la consulta final y AHORA SÍ cargamos las fotos
        usuarios_db = query.with_attached_foto_perfil
                           .order(id: :desc)
                           .limit(per_page)
                           .offset((page - 1) * per_page)

        usuarios_list = usuarios_db.map do |u|
          perfil = Perfil.find_by(id: u.idPerfil)
          {
            id: u.id,
            strNombreUsuario: u.strNombreUsuario,
            strCorreo: u.strCorreo,
            strNumeroCelular: u.strNumeroCelular,
            idEstadoUsuario: u.idEstadoUsuario,
            perfil_nombre: perfil ? perfil.strNombrePerfil : 'Sin Perfil',
            idPerfil: u.idPerfil,
            foto_url: u.foto_perfil.attached? ? url_for(u.foto_perfil) : nil
          }
        end

        render json: {
          usuarios: usuarios_list,
          perfiles: Perfil.all.select(:id, :strNombrePerfil),
          total_paginas: total_paginas,
          pagina_actual: page,
          # Usamos view_context para enviar los permisos seguros a JavaScript
          permisos: {
            editar: view_context.puede_editar?("usuario"),
            eliminar: view_context.puede_eliminar?("usuario")
          }
        }
      end
    end
  end

  def create
    usuario = Usuario.new(usuario_params)
    if usuario.save
      render json: { success: true, message: 'Usuario creado con éxito' }
    else
      render json: { success: false, errors: usuario.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    usuario = Usuario.find(params[:id])
    params_to_update = usuario_params
    params_to_update.delete(:password) if params_to_update[:password].blank?

    if usuario.update(params_to_update)
      render json: { success: true, message: 'Usuario actualizado' }
    else
      render json: { success: false, errors: usuario.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    Usuario.find(params[:id]).destroy
    render json: { success: true, message: 'Usuario eliminado' }
  end

  private

  def usuario_params
    params.require(:usuario).permit(:strNombreUsuario, :strCorreo, :strNumeroCelular, :idPerfil, :idEstadoUsuario, :password, :foto_perfil)
  end

  def validar_acceso(nombre_modulo, tipo_permiso)
    modulo = Modulo.find_by(strNombreModulo: nombre_modulo)
    permiso = PermisosPerfil.find_by(idPerfil: usuario_actual.idPerfil, idModulo: modulo&.id)

    unless permiso&.send(tipo_permiso)
      respond_to do |format|
        format.html { redirect_to dashboard_path, alert: "No tienes permiso para esta acción." }
        format.json { render json: { success: false, errors: ["Acceso denegado"] }, status: :forbidden }
      end
    end
  end
end