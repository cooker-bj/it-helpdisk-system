class AddCreatorIdAndCreatedTypeToItCases < ActiveRecord::Migration
  def change
    add_column :it_cases, :creator_id, :string
    add_column :it_cases, :created_type, :string
  end
end
