class Usuario < ApplicationRecord
  # Esta es la "magia" que encripta las contraseñas usando bcrypt
  has_secure_password

  has_one_attached :foto
end