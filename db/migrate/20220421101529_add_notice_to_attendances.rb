class AddNoticeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :indicator_reply, :integer
    add_column :attendances, :change, :boolean, default:false
  end
end
