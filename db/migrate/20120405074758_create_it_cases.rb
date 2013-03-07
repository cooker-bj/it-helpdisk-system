class CreateItCases < ActiveRecord::Migration
  def change
    create_table :it_cases do |t|
      t.string :user_id
      t.string :name
      t.string :department
      t.string :email
      t.string :phone
      t.string :location
      t.string :cubnum
      t.text :description
      t.string :casetype

      t.timestamps
    end
  end
end
