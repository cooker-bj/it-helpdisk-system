class AddOpenedTimeToItCases < ActiveRecord::Migration
  def change
    add_column :it_cases, :opened_time, :datetime
  end
end
