class AddPermissionToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :instructor_comp_reply, :string
    add_column :users, :change_comp, :boolean, default:false
  end
end
