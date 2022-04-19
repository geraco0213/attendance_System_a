class AddInstructorTestToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :instructor_test, :integer
  end
end
