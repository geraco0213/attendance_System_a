module UsersHelper
  
  
  def format_basic_info(time)
    format("%.2f",((time.hour*60)+time.min)/60.0)
  end
  
  
  def attendance_state(attendance)
    if Date.current==attendance.worked_on
      return '出社' if attendance.started_at.nil?
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    false
  end
  
  
  def overtime_state(attendance)
    if attendance.instructor_test.present? && ! attendance.change?
      return "#{attendance.instructor_test}に残業申請中"
    elsif attendance.change?
      if attendance.instructor_reply==2
        return "残業承認済"
      elsif attendance.instructor_reply==3
        return "残業否認"
      elsif day.instructor_reply==1
        return "#{attendance.instructor_test}に残業申請中"
      else
        return "#{attendance.instructor_test}に残業申請中"
      end
    end
  end
  
  
  
  def one_month_state(attendance)
    if attendance.instructor_one_month_test.present? && ! attendance.change_one_month?
      return "#{attendance.instructor_one_month_test}に勤怠編集申請中"
    elsif attendance.change_one_month?
      if attendance.instructor_one_month_reply==2
        return "勤怠編集承認済"
      elsif attendance.instructor_one_month_reply==3
        return "勤怠編集否認"
      elsif attendance.instructor_one_month_reply==1
        return "#{attendance.instructor_one_month_test}に残業申請中"
      else
        return "#{attendance.instructor_one_month_test}に残業申請中"
      end
    end
  end
  
  
  def comp_state(attendance)
    if attendance.instructor_comp_test.blank? 
      return "所属長承認　未"
    elsif attendance.instructor_comp_test.present? && ! attendance.change_comp?
      return "#{attendance.instructor_comp_test}に勤怠申請中"
    elsif attendance.change_comp?
      if attendance.instructor_comp_reply==2
        return "勤怠承認済"
      elsif attendance.instructor_comp_reply==3
        return "勤怠否認"
      elsif attendance.instructor_comp_reply==1
        return "#{attendance.instructor_comp_test}に勤怠申請中"
      else
        return "#{attendance.instructor_comp_test}に勤怠申請中"
      end
    end
  end
  
  
end
