class CreatePerfils < ActiveRecord::Migration[8.1]
  def change
    create_table :perfils do |t|
      t.string :strNombrePerfil
      t.boolean :bitAdministrador

      t.timestamps
    end
  end
end
