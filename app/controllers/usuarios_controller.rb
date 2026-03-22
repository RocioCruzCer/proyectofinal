class UsuariosController < ApplicationController
  # Incluimos el helper para generar URLs de las fotos
  include Rails.application.routes.url_helpers

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
            # Generamos la URL de la foto si está adjunta
            foto_url: u.foto_perfil.attached? ? url_for(u.foto_perfil) : nil
          }
        end

        render json: {
          usuarios: usuarios_list,
          perfiles: Perfil.all.select(:id, :strNombrePerfil),
          total_paginas: total_paginas,
          pagina_actual: page
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
    
    # Preparamos los parámetros (evitamos pisar la contraseña si viene vacía)
    params_to_update = usuario_params
    if params_to_update[:password].blank?
      params_to_update.delete(:password)
    end

    if usuario.update(params_to_update)
      render json: { success: true, message: 'Usuario actualizado' }
    else
      render json: { success: false, errors: usuario.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    Usuario.find(params[:id]).destroy
    render json: { success: true }
  end

  private

  def usuario_params
    params.require(:usuario).permit(:strNombreUsuario, :strCorreo, :strNumeroCelular, :idPerfil, :idEstadoUsuario, :password, :foto_perfil)
  end
end