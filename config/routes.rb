NhsPatientlist::Application.routes.draw do
  devise_for :users

  resources :users, only: [] do
    resources :patient_lists
  end

  resources :lists do
    resources :handovers, :only => [:new, :create]
  end

  resources :memberships, :only => [:create, :destroy, :update]

  resources :to_do_items do
    member do
      put :pending
      put :done
    end
  end

  resources :teams, :only => [:index]
  resources :team_members, :only => [:create]

  root :to => "lists#index"
end
