Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations' }

  resources :posts do
    collection do
      get :generate_report
    end
    member do
      put :approve
      put :reject
      put :submit_for_review
    end
  end

  namespace :users do
    resources :registrations
  end

  namespace :admin do
    resources :users do
      collection do
        patch :assign_admin_role
      end
    end
  end

  root 'posts#index'
end
