class PermisosController < ApplicationController
  # Filtro de seguridad para acceso HTML
  before_action :exigir_permiso_html, only: [:index]

  # GET /permisos
  def index
    @perfiles = Perfil.all.order(:strNombrePerfil)
  end

  # GET /permisos/buscar.json?perfil_id=1
  def buscar
    # 1. Seguridad: Verificar que pueda consultar
    unless puede_consultar?("permisosperfil")
      return render json: { success: false, errors: ["No autorizado"] }, status: :forbidden
    end

    perfil_id = params[:perfil_id]
    permisos_existentes = PermisosPerfil.where(idPerfil: perfil_id).index_by(&:idModulo)

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

    # 2. MAGIA: Envolvemos la matriz e inyectamos los permisos de edición
    render json: {
      modulos_agrupados: matriz_agrupada,
      permisos_acciones: {
        can_edit: view_context.puede_editar?("permisosperfil") || view_context.puede_agregar?("permisosperfil")
      }
    }
  end

  # POST /permisos/guardar_matriz
  def guardar_matriz
    # 3. Seguridad Backend: Bloqueamos guardado si no tiene permiso
    unless puede_editar?("permisosperfil") || puede_agregar?("permisosperfil")
      return render json: { success: false, errors: ["No tienes permiso para modificar la matriz."] }, status: :forbidden
    end

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

  private

  def exigir_permiso_html
    unless puede_consultar?("permisosperfil")
      redirect_to dashboard_path, alert: "Acceso denegado a Permisos Perfil."
    end
  end
end