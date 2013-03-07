class AddIpaddressAndStatusToItCases < ActiveRecord::Migration
  def change
    add_column :it_cases, :ipaddress, :string
    add_column :it_cases, :status, :string
  end
end
