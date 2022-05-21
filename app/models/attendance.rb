class Attendance < ApplicationRecord
  belongs_to :user
  
  
  
  validates :worked_on, presence:true
  validates :note, length:{maximum:50}
  
  validate :finished_at_is_invalid_without_a_started_at
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at,"が必要です") if started_at.blank? && finished_at.present?
  end
  
  validate :started_at_than_finished_at_fast_if_invalid
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present? && !tomorrow_one_month? && instructor_one_month_test.present?     #上司が入力されていないと時は、申請にならないので、出>退でも構わない#
      errors.add(:started_at, "より早い時間は無効です。") if started_at > finished_at
    end
  end
  
  
  
end
