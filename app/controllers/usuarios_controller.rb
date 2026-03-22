class UsuariosController < ApplicationController
  include Rails.application.routes.url_helpers
  
  # Filtro de seguridad: Verifica si el usuario tiene permiso de consulta para ver la lista
  before_action -> { validar_acceso("usuario", :bitConsulta) }, only: [:index]
  # Verifica permisos específicos para acciones de escritura
  before_action -> { validar_acceso("usuario", :bitAgregar) }, only: [:create]
  before_action -> { validar_acceso("usuario", :bitEditar) }, only: [:update]
  before_action -> { validar_acceso("usuario", :bitEliminar) }, only: [:destroy]

  def index
    respond_to do |format|
      format.html
      format.json do
        page = (params[:page] || 1).to_i
        per_page = 5
        
        total_registros = Usuario.count
        total_paginas = (total_registros.to_f / per_page).ceil
        
        usuarios_db = Usuario.with_attached_foto_perfil
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

        # Aquí enviamos también los permisos que tiene el usuario actual sobre este módulo
        # para que el JavaScript pueda ocultar o mostrar botones de editar/borrar
        mis_permisos = PermisosPerfil.find_by(idPerfil: usuario_actual.idPerfil, idModulo: Modulo.find_by(strNombreModulo: "usuario")&.id)

        render json: {
          usuarios: usuarios_list,
          perfiles: Perfil.all.select(:id, :strNombrePerfil),
          total_paginas: total_paginas,
          pagina_actual: page,
          permisos_acciones: {
            can_edit: mis_permisos&.bitEditar || false,
            can_delete: mis_permisos&.bitEliminar || false,
            can_add: mis_permisos&.bitAgregar || false
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

  # Método genérico para validar permisos desde el controlador
  def validar_acceso(nombre_modulo, tipo_permiso)
    modulo = Modulo.find_by(strNombreModulo: nombre_modulo)
    permiso = PermisosPerfil.find_by(idPerfil: usuario_actual.idPerfil, idModulo: modulo&.id)

    # Si no tiene el bit correspondiente activado (ej: bitConsulta, bitEditar)
    unless permiso&.send(tipo_permiso)
      respond_to do |format|
        format.html { redirect_to dashboard_path, alert: "No tienes permiso para esta acción." }
        format.json { render json: { success: false, errors: ["Acceso denegado"] }, status: :forbidden }
      end
    end
  end
end