Rails.application.routes.draw do
  root 'static_pages#top'

  get 'signup' , to: 'users#new'
  
  get 'login', to: 'sessions#new'
  post 'login' ,to: 'sessions#create'
  delete 'logout' ,to: 'sessions#destroy'
  

  resources :users do
    member do
      get 'attendances/edit_one_month_request'
      patch 'attendances/update_one_month_request'
      get 'attendances/edit_overtime_notice'
      patch 'attendances/update_overtime_notice'
      get 'attendances/edit_one_month_notice'
      patch 'attendances/update_one_month_notice'
      patch 'update_comp_request'
      get 'edit_comp_notice'
      patch 'update_comp_notice'
    end
    
    resources :attendances, only: :update do
      member do
        get 'edit_overtime_request'
        patch 'update_overtime_request'
      end
      
    end
  end
  
end