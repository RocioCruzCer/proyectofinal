class Perfil < ApplicationRecord
  has_many :usuarios, foreign_key: 'idPerfil'
end