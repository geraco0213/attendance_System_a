class AddCheckToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :instructor_comp_test, :string
  end
end
