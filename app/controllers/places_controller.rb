class PlacesController < ApplicationController
  before_action :set_place, only:[:edit, :update, :destroy]
  
  
  def index
    @places=Place.all
  end
  
  
  def new
    @place=Place.new
  end
  
  def create
    @place=Place.new(place_params)
    if @place.save
      flash[:success]="新規作成に成功しました"
      redirect_to places_url
    else
      render :new
    end
  end
  
   

  
  
  def edit
  end
  
  
  
  def update
    if @place.update_attributes(place_params)
    flash[:success]="更新しました"
    end
  end
  
  
  def destroy
    @place.destroy
    flash[:success]="#{@place.name}を削除しました"
    redirect_to places_url
  end
  
  
  private
    def place_params
      params.require(:place).permit(:number, :name, :working_style)
    end
    
  

end