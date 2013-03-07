class CreateRights < ActiveRecord::Migration
  def change
    create_table :rights do |t|
      t.integer :management_id
      t.string :name

      t.timestamps
    end
  end
end
