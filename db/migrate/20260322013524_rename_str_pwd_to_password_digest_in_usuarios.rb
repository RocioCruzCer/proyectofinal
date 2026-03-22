class RenameStrPwdToPasswordDigestInUsuarios < ActiveRecord::Migration[7.1]
  def change
    # Cambiamos el nombre de la columna vieja a la que pide Rails por estándar
    rename_column :usuarios, :strPwd, :password_digest
  end
end