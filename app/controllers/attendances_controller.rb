class AttendancesController < ApplicationController
  before_action :set_user, only:[:edit_one_month,:update_one_month]
  before_action :logged_in_user, only:[:update,:edit_one_month,:update_one_month] 
  before_action :admin_or_correct_or_superior_user, only:[:update,:edit_one_month,:update_one_month]  #superiorを追記#
  before_action :set_one_month, only:[:edit_one_month]
  
  UPDATE_ERROR_MSG="勤怠登録に失敗しました。やり直してください"
  def update
    @user=User.find(params[:user_id])
    @attendance= @user.attendances.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at:Time.current.change(sec:0))
        flash[:info]="おはようございます。"
      else
        flash[:danger]=UPDATE_ERROR_MSG
      end
      
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at:Time.current.change(sec:0))
        flash[:info]="お疲れ様でした"
      else
        flash[:danger]=UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  
  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid 
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  
  #残業の申請ページ#
  def edit_overtime_request
    @user = User.find(params[:user_id])
    @attendance=@user.attendances.find(params[:id])
    @superior=User.where(superior:true).where.not(id:@user.id)
  end
  
  #残業の申請内容が送信されるページ#
  def update_overtime_request
    @user= User.find(params[:user_id])
    @attendance= @user.attendances.find(params[:id])
    if @attendance.update_attributes(overtime_request_params)
       flash[:success]="残業申請を受け付けました"
    else 
      flash[:danger]="入力に不備があり、申請をキャンセルしました"
    end
    redirect_to user_url(@user) 
  end
    
  
  
  #残業の申請内容を見て承認するページ#
  def edit_overtime_notice
    @user=User.find(params[:id])
    @attendances=Attendance.where(instructor_test:@user.name).where(change:false)
  end
  
  #残業の承認内容が送信されるページ#
  def update_overtime_notice
    @user=User.find(params[:id])
    ActiveRecord::Base.transaction do
      overtime_permit_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url
  rescue ActiveRecord::RecordInvalid 
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_overtime_notice_user_url
  end
  
  

    
  

  private
    def attendances_params
      params.require(:user).permit(attendances:[:started_at, :finished_at, :note])[:attendances]
    end
    
    def overtime_request_params
      params.require(:attendance).permit(:scheduled_end_time,:business_outline,:tomorrow,:instructor_test)
    end
    
    def overtime_permit_params
      params.require(:user).permit(attendances:[:instructor_reply, :change, :user_id])[:attendances]
    end
    
    
    
    
end
