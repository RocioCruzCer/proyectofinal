module ApplicationHelper
  # 1. Función base para encontrar el permiso sin repetir código
  def permiso_para(nombre_modulo)
    return nil unless usuario_logueado?
    modulo = Modulo.where("LOWER(TRIM(strNombreModulo)) = ?", nombre_modulo.downcase.strip).first
    return nil unless modulo
    PermisosPerfil.find_by(idPerfil: usuario_actual.idPerfil, idModulo: modulo.id)
  end

  # 2. Revisa la palomita de "Consultar" (Para ver menús y listas)
  def tiene_permiso?(nombre_modulo)
    permiso = permiso_para(nombre_modulo)
    permiso ? permiso.bitConsulta : false
  end

  # 3. Revisa la palomita de "Agregar"
  def puede_agregar?(nombre_modulo)
    permiso = permiso_para(nombre_modulo)
    permiso ? permiso.bitAgregar : false
  end

  # 4. Revisa la palomita de "Editar"
  def puede_editar?(nombre_modulo)
    permiso = permiso_para(nombre_modulo)
    permiso ? permiso.bitEditar : false
  end

  # 5. Revisa la palomita de "Eliminar"
  def puede_eliminar?(nombre_modulo)
    permiso = permiso_para(nombre_modulo)
    permiso ? permiso.bitEliminar : false
  end
end