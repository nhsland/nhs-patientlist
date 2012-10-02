NhsPatientlist::Application.routes.draw do
  resources :grades

  devise_for :users

  resources :users, only: [] do
    resources :patient_lists
  end

  resources :lists
  resources :handover_lists
  resources :memberships, :only => [:create, :destroy, :update]

   resources :to_do_items do
    resources :handovers, :only => [:new, :create], :controller => "to_do_items/handovers"
  end

  resources :teams, :only => [:index]
  resources :team_members, :only => [:create]
  resources :handovers

  match 'memberships' => 'memberships#create', via: :post
  match 'memberships/:patient_id/:patient_list_id' => 'memberships#destroy', via: :delete

  root :to => "lists#index"
end
