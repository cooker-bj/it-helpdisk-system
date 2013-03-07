class AddBeginTimeToItCases < ActiveRecord::Migration
  def change
    add_column :it_cases, :begin_time, :datetime
  end
end
