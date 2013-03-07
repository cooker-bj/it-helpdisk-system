class AddGuestNameAndGuestFromToApplicate < ActiveRecord::Migration
  def change
    add_column :applicates, :guest_name, :string
    add_column :applicates, :guest_from, :string
  end
end
