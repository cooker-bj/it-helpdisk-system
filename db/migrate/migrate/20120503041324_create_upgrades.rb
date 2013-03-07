class CreateUpgrades < ActiveRecord::Migration
  def change
    create_table :upgrades do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.text :reason
      t.integer :task_id

      t.timestamps
    end
  end
end
