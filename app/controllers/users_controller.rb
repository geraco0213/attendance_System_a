class UsersController < ApplicationController
  before_action :set_user, only:[:show, :edit,:update,:destroy]
  before_action :logged_in_user, only:[:index, :show, :edit,:update,:destroy] 
  before_action :correct_user, only:[:edit, :update]
  before_action :admin_user, only:[:index,:destroy]
  before_action :admin_or_correct_or_superior_user, only: :show  #superiorを追記#
  before_action :set_one_month, only: [:show]
  
  
  def new
    if logged_in?
      flash[:info]="すでにログインしています"
      redirect_to current_user
    end
    @user=User.new
  end
  
  def create
    @user=User.new(user_params)
    if @user.save
      log_in @user
      flash[:success]="新規作成に成功しました"
      redirect_to @user
    else
      render :new
    end
  end
  
  def index
    @users=User.paginate(page:params[:page], per_page:30)
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at:nil).count
    #追記#
    @requested_attendances=Attendance.where(instructor_test:@user.name).where(change:false)  
    @one_month_requested_attendances=Attendance.where(instructor_one_month_test:@user.name).where(change_one_month:false)
    
    #以下、勤怠完全版申請に必要#
    @superior=User.where(superior:true).where.not(id:@user.id)  
    @attendance=@user.attendances.find_by(worked_on:@first_day)
    @comp_requested_attendances=Attendance.where(instructor_comp_test:@user.name).where(change_comp:false)
  end
    
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success]="ユーザー情報を編集しました"
      redirect_to @user
    else
      render :edit
    end
  end
    
  def destroy
    @user.destroy
    flash[:danger]="#{@user.name}を削除しました"
    redirect_to users_url
  end
  
  
  def update_basic_info
    @user=User.find(params[:id])
    if @user.update_attributes(basic_info_params)
      flash[:success]="基本情報を編集しました"
    end
    redirect_to users_url
  end
    
  
  
  def import
    if params[:csv_file].blank?
      flash[:danger] = "読み込むCSVを選択してください"
      redirect_to users_url
    elsif File.extname(params[:csv_file].original_filename) != ".csv"
      flash[:danger] = "csvファイルのみ読み込み可能です"
      redirect_to users_url
    else
     ActiveRecord::Base.transaction do
      User.import(params[:csv_file])
       if 0
         flash[:success] = "データ情報を追加しました"
       else
         flash[:success] = "データ情報を更新しました"
       end
       redirect_to users_url
     rescue ActiveRecord::RecordInvalid 
       flash[:danger] = "無効な入力データがあった為、処理をキャンセルしました。"
       redirect_to users_url
     end
    end
  end
  
  
  private  #部署などの基本情報はまだ#
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
    
    
    def basic_info_params
      params.require(:user).permit(:name,:email, :password, :password_confirmation,
      :employee_number, :uid, :affiliation, :basic_work_time, :designated_work_start_time, :designated_work_finish_time)
    end
  
end
