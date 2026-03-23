class Usuario < ApplicationRecord
  # Esta es la "magia" que encripta las contraseñas usando bcrypt
  has_secure_password
  has_one_attached :foto_perfil


  belongs_to :perfil, class_name: 'Perfil', foreign_key: 'idPerfil', optional: true
end

