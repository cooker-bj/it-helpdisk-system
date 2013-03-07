class AddEmailAndDepartmentToManagements < ActiveRecord::Migration
  def change
    add_column :managements, :email, :string
    add_column :managements, :department, :string
  end
end
