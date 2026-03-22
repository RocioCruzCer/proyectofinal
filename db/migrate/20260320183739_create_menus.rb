class CreateMenus < ActiveRecord::Migration[8.1]
  def change
    create_table :menus do |t|
      t.integer :idMenu
      t.integer :idModulo

      t.timestamps
    end
  end
end
