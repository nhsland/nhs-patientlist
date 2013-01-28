NhsPatientlist::Application.routes.draw do
  devise_for :users

  resources :patient_lists do
    resources :handovers, :only => [:new, :create]
  end

  resources :memberships, :only => [:create, :destroy, :update]

  resources :to_do_items

  resources :patient_history, only: [:show]

  root :to => "patient_lists#index"
end
