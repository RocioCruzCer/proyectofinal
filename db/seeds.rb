# 1. CREACIÓN DE MÓDULOS BASE
# Estos nombres deben coincidir EXACTAMENTE con los que usas en el Layout y en 'tiene_permiso?'
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

# 3. CREACIÓN DEL USUARIO (Tu código original mejorado)
puts "Sembrando usuario administrador..."
usuario_admin = Usuario.find_or_create_by!(strCorreo: "admin@sistema.com") do |usuario|
  usuario.strNombreUsuario = "Admin"
  usuario.strNumeroCelular = "5551234567"
  usuario.idPerfil = perfil_admin.id
  usuario.idEstadoUsuario = 1
  usuario.password = "Password123!"
end

# 4. ASIGNACIÓN DE PERMISOS TOTALES AL PERFIL 1
# Esto es vital para que al entrar veas todo el menú dinámico
puts "Asignando permisos totales al perfil Administrador..."
Modulo.all.each do |mod|
  PermisosPerfil.find_or_create_by!(idPerfil: perfil_admin.id, idModulo: mod.id) do |permiso|
    permiso.bitConsulta = true
    permiso.bitAgregar  = true
    permiso.bitEditar   = true
    permiso.bitEliminar = true
    permiso.bitDetalle  = true
  end
end

puts "¡Sembrado completado con éxito!"