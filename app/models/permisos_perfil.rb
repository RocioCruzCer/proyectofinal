class PermisosPerfil < ApplicationRecord
  # se indica manualmente las llaves foráneas para que Rails no se pierda
  belongs_to :perfil, foreign_key: 'idPerfil'
  belongs_to :modulo, foreign_key: 'idModulo'
end