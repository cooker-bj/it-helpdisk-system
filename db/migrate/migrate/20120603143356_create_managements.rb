class CreateManagements < ActiveRecord::Migration
  def change
    create_table :managements do |t|
      t.string :user
      t.string :userid

      t.timestamps
    end
  end
end
