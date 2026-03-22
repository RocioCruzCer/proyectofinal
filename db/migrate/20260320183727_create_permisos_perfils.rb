class CreatePermisosPerfils < ActiveRecord::Migration[8.1]
  def change
    create_table :permisos_perfils do |t|
      t.integer :idModulo
      t.integer :idPerfil
      t.boolean :bitAgregar
      t.boolean :bitEditar
      t.boolean :bitConsulta
      t.boolean :bitEliminar
      t.boolean :bitDetalle

      t.timestamps
    end
  end
end
