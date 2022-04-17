class SessionsController < ApplicationController
  
  def new
    if logged_in?
      flash[:success]="すでにログインしています"
      redirect_to user
    end
  end
  
  def create
    user=User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me]== '1' ? remember(user) : forget(user)
      flash[:success]="ログインしました"
      redirect_back_or_user
    else
      flash.now[:danger]="認証に失敗しました"
      render :new
    end
    
  end

  def destroy
    log_out if logged_in?
    flash[:success]="ログアウトしました"
    redirect_to root_url
  end
  
    
  private
  
  
end
