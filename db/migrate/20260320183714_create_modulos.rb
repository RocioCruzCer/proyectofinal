class CreateModulos < ActiveRecord::Migration[8.1]
  def change
    create_table :modulos do |t|
      t.string :strNombreModulo

      t.timestamps
    end
  end
end
