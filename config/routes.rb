Rails.application.routes.draw do
  root 'static_pages#top'

  get 'signup' , to: 'users#new'
  
  get 'login', to: 'sessions#new'
  post 'login' ,to: 'sessions#create'
  delete 'logout' ,to: 'sessions#destroy'
  

  resources :users do
    member do
      patch 'update_basic_info'
      get 'attendances/edit_one_month_request'
      patch 'attendances/update_one_month_request'
      get 'attendances/edit_overtime_notice'
      patch 'attendances/update_overtime_notice'
      get 'attendances/edit_one_month_notice'
      patch 'attendances/update_one_month_notice'
      get 'attendances/edit_comp_notice'
      patch 'attendances/update_comp_notice'
      get 'attendances/working'
      get 'attendances/history'
      get 'attendances/output'
    end
    
    #CSV#
    collection {post :import}
    
    resources :attendances, only: :update do
      member do
        get 'edit_overtime_request'
        patch 'update_overtime_request'
        patch 'update_comp_request'
      end
      
    end
  end
  
  resources :places 
  
end