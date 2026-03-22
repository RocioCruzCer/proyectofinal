# 1. CREACIÓN DE MÓDULOS BASE
modulos_sistema = [
  'seguridad', 'perfil', 'modulo', 'permisosperfil', 'usuario',
  'principal1', 'principal1_1', 'principal1_2',
  'principal2', 'principal2_1', 'principal2_2'
]

puts "Sembrando módulos..."
modulos_sistema.each do |nombre|
  Modulo.find_or_create_by!(strNombreModulo: nombre)
end

# 2. CREACIÓN/VERIFICACIÓN DEL PERFIL ADMINISTRADOR
# Asumimos que el ID 1 es para el Administrador
perfil_admin = Perfil.find_or_create_by!(id: 1) do |p|
  p.strNombrePerfil = "Administrador"
end

# 3. CREACIÓN DEL USUARIO
puts "Sembrando usuario administrador..."
Usuario.find_or_create_by!(strCorreo: "admin@sistema.com") do |usuario|
  usuario.strNombreUsuario = "Admin"
  usuario.strNumeroCelular = "5551234567"
  usuario.idPerfil = perfil_admin.id
  usuario.idEstadoUsuario = 1
  usuario.password = "Password123!"
end

# 4. ASIGNACIÓN DE PERMISOS TOTALES AL PERFIL 1
puts "Asignando permisos totales al perfil Administrador..."
Modulo.all.each do |mod|
  # Buscamos o creamos el registro
  permiso = PermisosPerfil.find_or_create_by!(idPerfil: perfil_admin.id, idModulo: mod.id)
  
  # Usamos update! para FORZAR que se guarden como true, aunque ya existieran en false
  permiso.update!(
    bitConsulta: true,
    bitAgregar:  true,
    bitEditar:   true,
    bitEliminar: true,
    bitDetalle:  true
  )
end

puts "¡Sembrado completado con éxito!"