# find_or_create_by! busca si ya existe el correo. Si no existe, lo crea.
# Esto evita que se duplique el usuario si ejecutamos esto varias veces.
Usuario.find_or_create_by!(strCorreo: "admin@sistema.com") do |usuario|
  usuario.strNombreUsuario = "Admin"
  usuario.strNumeroCelular = "5551234567"
  usuario.idPerfil = 1
  usuario.idEstadoUsuario = 1
  usuario.password = "Password123!"
end

puts "¡Usuario administrador sembrado con éxito!"