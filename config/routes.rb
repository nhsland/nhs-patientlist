NhsPatientlist::Application.routes.draw do
  devise_for :users

  resources :users, only: [] do
    resources :patient_lists
  end

  resources :lists

  resources :memberships, :only => [:create, :destroy, :update]

  resources :to_do_items do
    member do
      put :pending
      put :done
    end
  end

  resources :teams, :only => [:index]
  resources :team_members, :only => [:create]

  match 'memberships' => 'memberships#create', via: :post
  match 'memberships/:patient_id/:patient_list_id' => 'memberships#destroy', via: :delete

  root :to => "lists#index"
end
