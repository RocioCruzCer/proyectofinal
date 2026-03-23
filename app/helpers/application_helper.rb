module ApplicationHelper
  # 1. Función base blindada contra nulos y mayúsculas de PostgreSQL
  def permiso_para(nombre_modulo)
    return nil unless usuario_logueado?
    return nil if nombre_modulo.blank? # <-- PROTECCIÓN: Si llega vacío o nil, se detiene aquí

    # Convertimos a texto de forma segura antes de limpiar espacios y mayúsculas
    nombre_limpio = nombre_modulo.to_s.downcase.strip
    
    # <-- MAGIA DE POSTGRESQL: Comillas dobles escapadas (\") para respetar tus mayúsculas
    modulo = Modulo.where("LOWER(TRIM(\"strNombreModulo\")) = ?", nombre_limpio).first
    
    return nil unless modulo
    PermisosPerfil.find_by(idPerfil: usuario_actual.idPerfil, idModulo: modulo.id)
  end

  # 2. Revisa Consultar (menús y ver listas)
  def tiene_permiso?(nombre_modulo)
    permiso = permiso_para(nombre_modulo)
    permiso&.bitConsulta == true # <-- Usamos el operador seguro &
  end

  # 3. Revisa Agregar (Botones de + Nuevo)
  def puede_agregar?(nombre_modulo)
    permiso = permiso_para(nombre_modulo)
    permiso&.bitAgregar == true
  end

  # 4. Revisa Editar
  def puede_editar?(nombre_modulo)
    permiso = permiso_para(nombre_modulo)
    permiso&.bitEditar == true
  end

  # 5. Revisa Eliminar
  def puede_eliminar?(nombre_modulo)
    permiso = permiso_para(nombre_modulo)
    permiso&.bitEliminar == true
  end
end