class CreateUsuarios < ActiveRecord::Migration[8.1]
  def change
    create_table :usuarios do |t|
      t.string :strNombreUsuario
      t.integer :idPerfil
      t.string :strPwd
      t.integer :idEstadoUsuario
      t.string :strCorreo
      t.string :strNumeroCelular

      t.timestamps
    end
  end
end
