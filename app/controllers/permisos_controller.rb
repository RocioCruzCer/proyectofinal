class PermisosController < ApplicationController
  # GET /permisos
  def index
    @perfiles = Perfil.all.order(:strNombrePerfil)
  end

  # Acción para obtener todos los módulos agrupados y los permisos actuales del perfil
  # GET /permisos/buscar.json?perfil_id=1
  def buscar
    perfil_id = params[:perfil_id]
    
    # Buscamos qué permisos ya existen para este perfil
    permisos_existentes = PermisosPerfil.where(idPerfil: perfil_id).index_by(&:idModulo)

    # Función auxiliar (Lambda) para no repetir código. Arma el JSON de cada fila.
    armar_permiso = ->(m) do
      p = permisos_existentes[m.id]
      {
        idModulo: m.id,
        nombreModulo: m.strNombreModulo,
        bitAgregar: p ? p.bitAgregar : false,
        bitEditar: p ? p.bitEditar : false,
        bitEliminar: p ? p.bitEliminar : false,
        bitConsulta: p ? p.bitConsulta : false,
        bitDetalle: p ? p.bitDetalle : false
      }
    end

    # Armamos la matriz como un Diccionario (Hash), agrupando por títulos
    # y excluyendo las palabras padre para que no tengan checkboxes.
    matriz_agrupada = {
      "SEGURIDAD" => Modulo.where(strNombreModulo: ['perfil', 'modulo', 'permisosperfil', 'usuario']).map(&armar_permiso),
      "PRINCIPAL 1" => Modulo.where(strNombreModulo: ['principal1_1', 'principal1_2']).map(&armar_permiso),
      "PRINCIPAL 2" => Modulo.where(strNombreModulo: ['principal2_1', 'principal2_2']).map(&armar_permiso),
      "MÓDULOS EXTRA" => Modulo.where.not(strNombreModulo: [
        'seguridad', 'perfil', 'modulo', 'permisosperfil', 'usuario', 
        'principal1', 'principal1_1', 'principal1_2', 
        'principal2', 'principal2_1', 'principal2_2'
      ]).map(&armar_permiso)
    }

    # Mandamos el JSON estructurado por grupos
    render json: matriz_agrupada
  end

  # Acción para guardar toda la tabla de una vez
  # POST /permisos/guardar_matriz
  def guardar_matriz
    perfil_id = params[:idPerfil]
    permisos_data = params[:permisos]

    begin
      PermisosPerfil.transaction do
        permisos_data.each do |data|
          permiso = PermisosPerfil.find_or_initialize_by(idPerfil: perfil_id, idModulo: data[:idModulo])
          permiso.update!(
            bitAgregar: data[:bitAgregar],
            bitEditar: data[:bitEditar],
            bitEliminar: data[:bitEliminar],
            bitConsulta: data[:bitConsulta],
            bitDetalle: data[:bitDetalle]
          )
        end
      end
      render json: { success: true, message: "Permisos actualizados correctamente" }
    rescue => e
      render json: { success: false, errors: [e.message] }, status: :unprocessable_entity
    end
  end
end