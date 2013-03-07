class CreateWirelesses < ActiveRecord::Migration
  def change
    create_table :wirelesses do |t|
      t.integer :applicate_id
      t.string :account
      t.string :password
      t.datetime :enabled_time
      t.datetime :disabled_time
      t.boolean :actived, :null=>false,:default=>false

      t.timestamps
    end
  end
end
