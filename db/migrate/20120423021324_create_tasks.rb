class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :userid
      t.datetime :taken_date
      t.string :it_case_id
      t.datetime :finished_time
      t.string :status
      t.timestamps
    end
  end
end
