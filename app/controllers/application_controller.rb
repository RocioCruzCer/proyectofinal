class ApplicationController < ActionController::Base
  # 1. Seguridad global
  before_action :exigir_usuario_logueado

  # 2. Métodos disponibles en Vistas y Helpers (¡AQUÍ AGREGAMOS :puede_detalle?!)
  helper_method :usuario_actual, :usuario_logueado?, :puede_consultar?, 
                :puede_agregar?, :puede_editar?, :puede_eliminar?, :puede_detalle?

  private

  def usuario_actual
    if session[:usuario_id]
      @usuario_actual ||= Usuario.find_by(id: session[:usuario_id])
    end
  end

  def usuario_logueado?
    !!usuario_actual
  end

  def exigir_usuario_logueado
    unless usuario_logueado?
      redirect_to login_path, alert: "Debes iniciar sesión para acceder a esta sección."
    end
  end

  # --- Lógica de Permisos Corregida (Fase 4) ---

  def puede_consultar?(modulo); validar_permiso(modulo, :bitConsulta); end
  def puede_agregar?(modulo);   validar_permiso(modulo, :bitAgregar); end
  def puede_editar?(modulo);    validar_permiso(modulo, :bitEditar); end
  def puede_eliminar?(modulo);  validar_permiso(modulo, :bitEliminar); end
  
  # ¡AQUÍ AGREGAMOS LA LÍNEA DEL DETALLE!
  def puede_detalle?(modulo);   validar_permiso(modulo, :bitDetalle); end

  def validar_permiso(nombre_modulo, accion_bit)
    return false unless usuario_actual

    # 1. Buscar el perfil directamente por ID para evitar el error 'undefined method perfil'
    perfil = Perfil.find_by(id: usuario_actual.idPerfil)
    return true if perfil&.bitAdministrador 

    # 2. Buscar el módulo por su nombre para obtener el ID
    mod = Modulo.find_by(strNombreModulo: nombre_modulo)
    return false unless mod

    # 3. Buscar el permiso usando IDs directos (esto reemplaza el .joins que fallaba)
    permiso = PermisosPerfil.find_by(idPerfil: usuario_actual.idPerfil, idModulo: mod.id)
    
    # Retornar el valor del bit (true/false)
    permiso ? !!permiso[accion_bit] : false
  rescue => e
    logger.error "Error en validación de permisos: #{e.message}"
    false
  end
end