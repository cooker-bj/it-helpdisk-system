class AddDisabledToWireless < ActiveRecord::Migration
  def change
    add_column :wirelesses, :disabled, :boolean
  end
end
