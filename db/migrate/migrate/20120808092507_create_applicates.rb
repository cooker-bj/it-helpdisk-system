class CreateApplicates < ActiveRecord::Migration
  def change
    create_table :applicates do |t|
      t.string :user_id
      t.string :name
      t.string :department
      t.integer :number
      t.string :reason
      t.datetime :app_time
      t.datetime :enabled_time
      t.integer :during

      t.timestamps
    end
  end
end
