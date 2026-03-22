module ApplicationHelper
  def tiene_permiso?(nombre_modulo)
    return false unless usuario_logueado?
    
    # Buscamos el módulo por nombre
    modulo = Modulo.find_by(strNombreModulo: nombre_modulo)
    return false unless modulo

    # Buscamos el permiso para el perfil del usuario actual
    permiso = PermisosPerfil.find_by(idPerfil: usuario_actual.idPerfil, idModulo: modulo.id)
    
    # Si existe el registro y tiene bitConsulta activado, le damos acceso
    permiso&.bitConsulta || false
  end
end