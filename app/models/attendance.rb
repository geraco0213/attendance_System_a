class Attendance < ApplicationRecord
  belongs_to :user
  
  def user
    User.find(self.user_id)
  end
  
  validates :worked_on, presence:true
  validates :note, length:{maximum:50}
  
  validate :finished_at_is_invalid_without_a_started_at
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at,"が必要です") if started_at.blank? && finished_at.present?
  end
  
  validate :started_at_than_finished_at_fast_if_invalid
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い時間は無効です。") if started_at > finished_at
    end
  end
  
  #以下、残業系を追記#
  validates :scheduled_end_time, presence:true
  validates :business_outline, presence:true, length:{maximum:50}
  
end
