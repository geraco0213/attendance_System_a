class AddOktimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :reply_updated_at, :datetime
  end
end
