class AttendancesController < ApplicationController
  include AttendancesHelper
  
  before_action :set_user, only:[:edit_one_month_request,:update_one_month_request]
  before_action :logged_in_user, only:[:update,:edit_one_month_request,:update_one_month_request] 
  before_action :admin_or_correct_or_superior_user, only:[:update,:edit_one_month_request,:update_one_month_request]  #superiorを追記#
  before_action :set_one_month, only:[:edit_one_month_request]
  
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
  
  #１か月の勤怠編集を申請するページ#
  def edit_one_month_request
    @superior=User.where(superior:true).where.not(id:current_user.id)
  end
  
  #１か月の勤怠編集の申請内容が送信されるページ#
  def update_one_month_request
      ActiveRecord::Base.transaction do
        if attendance_invalid?
          attendances_params.each do |id, item|
            attendance = Attendance.find(id)
            attendance.update_attributes!(item)
            if attendance.change_one_month?
              attendance.update_attributes(change_one_month:false)
            end
          end
            flash[:success] = "1ヶ月分の勤怠情報を申請しました。"
            redirect_to user_url(date: params[:date])
        else
          flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました。"
          redirect_to attendances_edit_one_month_request_user_url(date: params[:date])
        end
      end 
  rescue ActiveRecord::RecordInvalid 
    flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました。"
    redirect_to attendances_edit_one_month_request_user_url(date: params[:date])
  end
  
  #１か月の勤怠編集の申請内容を見て承認するページ＃
  def edit_one_month_notice
    @user=User.find(params[:id])
    @attendances=Attendance.where(instructor_one_month_test:@user.name).where(change_one_month:false)
  end
  
  
  #１か月の勤怠編集の承認内容が送信されるページ#
  def update_one_month_notice
    ActiveRecord::Base.transaction do
      one_month_permit_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "承認完了"
    redirect_to user_url
  rescue ActiveRecord::RecordInvalid 
    flash[:danger] = "無効な入力データがあった為、承認をキャンセルしました。"
    redirect_to attendances_edit_overtime_notice_user_url
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
    if params[:attendance][:scheduled_end_time].blank? || params[:attendance][:business_outline].blank? || params[:attendance][:instructor_test].blank?
      flash[:danger]="入力に不備があり、申請をキャンセルしました"
    else
      @attendance.update_attributes(overtime_request_params)
      if @attendance.change?
        @attendance.update_attributes(change:false)
      end
      flash[:success]="残業申請を受け付けました"
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
    ActiveRecord::Base.transaction do
      overtime_permit_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "承認完了"
    redirect_to user_url
  rescue ActiveRecord::RecordInvalid 
    flash[:danger] = "無効な入力データがあった為、承認をキャンセルしました。"
    redirect_to attendances_edit_overtime_notice_user_url
  end
  
  #勤怠完全版申請が送信されるページ#
  def update_comp_request
    
    @user=User.find(params[:user_id])
    @attendance=@user.attendances.find(params[:id])  #ここ、@attendance=@user.attendances.find_by(worked_on:@first_day)より改変#
    if @attendance.update_attributes(comp_request_params)
      if @attendance.change_comp?
        @attendance.update_attributes(change_comp:false)
      end
      flash[:success]="申請しました"
    end
    redirect_to user_url(@user)
  end
  
  #勤怠完全版申請を見て承認するページ#
  def edit_comp_notice
    @user=User.find(params[:id])
    @attendances=Attendance.where(instructor_comp_test:@user.name).where(change_comp:false)
  end
  
  
  
  #勤怠完全版承認が送信されるページ#
  def update_comp_notice
    ActiveRecord::Base.transaction do
      comp_permit_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "承認完了"
    redirect_to user_url
  rescue ActiveRecord::RecordInvalid 
    flash[:danger] = "無効な入力データがあった為、承認をキャンセルしました。"
    redirect_to attendances_edit_comp_notice_user_url
  end
  
  
  def working
   @attendances=Attendance.where.not(started_at:nil).where(finished_at:nil)
  end
  

    
  

  private
    def attendances_params
      params.require(:user).permit(attendances:[:started_at, :finished_at, :note, :instructor_one_month_test, :tomorrow_one_month])[:attendances]
    end
    
    def overtime_request_params
      params.require(:attendance).permit(:scheduled_end_time,:business_outline,:tomorrow,:instructor_test)
    end
    
    def overtime_permit_params
      params.require(:user).permit(attendances:[:instructor_reply, :change, :user_id])[:attendances]
    end
    
    def one_month_permit_params
      params.require(:user).permit(attendances:[:instructor_one_month_reply, :change_one_month, :user_id])[:attendances]
    end
    
    def comp_request_params
      params.require(:attendance).permit(:instructor_comp_test)
    end
    
    def comp_permit_params
      params.require(:user).permit(attendances:[:instructor_comp_reply, :change_comp, :user_id])[:attendances]
    end
    
    
end
