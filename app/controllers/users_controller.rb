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
    
    @superior=User.where(superior:true).where.not(id:@user.id)  #勤怠完成版申請時に必要#
    @comp_requested_users=User.where(instructor_comp_test:@user.name).where(change_comp:false)
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
  
  
  
  #追記#
  #勤怠完全版の申請を受け取るページ#
  def update_comp_request
    @user=User.find(params[:id])
    if params[:user][:instructor_comp_test].blank?
      flash[:danger]="不備があり、申請を中止しました"
    elsif @user.update_attributes(comp_request_params)
      flash[:success]="勤怠編集を受け付けました"
    
    end
    redirect_to user_url(@user)
  end
  
  #勤怠完成版申請の内容を確認し、承認するページ#
  def edit_comp_notice
    @user=User.find(params[:id])
    @users=User.where(instructor_comp_test:@user.name).where(change_comp:false)
  end
  
  #勤怠完成版申請の承認が送信されるページ
  def update_comp_notice
  end
  
  
  private  #部署などの基本情報はまだ#
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
    
    def comp_request_params
      params.require(:user).permit(:instructor_comp_test)
    end
  
end
