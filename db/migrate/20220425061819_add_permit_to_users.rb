class AddPermitToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :instructor_comp_test, :integer
    add_column :users, :change_comp, :boolean, default:false
  end
end
