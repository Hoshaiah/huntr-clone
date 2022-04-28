Rails.application.routes.draw do

  resources :kanbans do
    resources :cards do
      resources :activities
    end

    get 'metrics/index'
  end

  devise_for :users
  get '/user' => "kanbans#index", :as => :user_root #redirects to kanbans/index upon login
  root to: 'pages#home'
  patch '/kanbans/:id/sort', to: 'kanbans#sort', as: "kanban_sort"

  post 'subscribe', to: 'card_subscription#subscribe'
  post 'details', to: 'card_subscription#details'
  post 'source/gcash', to: 'ewallet_subscription#gcash_source'
  post 'source/grabpay', to: 'ewallet_subscription#grabpay_source'
  post 'payments/grabpay', to: 'ewallet_subscription#grabpay_payment_success'
  post 'payments/gcash', to: 'ewallet_subscription#gcash_payment_success'

  get 'subscribe', to: 'card_subscription#subscribe'
  get 'payments/gcash/success', to: 'ewallet_subscription#gcash_payment_success'
  get 'payments/grabpay/success', to: 'ewallet_subscription#grabpay_payment_success'
  get 'subscription/card/success', to: 'card_subscription#card_success'
  get 'subscription/ewallet/failed', to: 'ewallet_subscription#ewallet_failed'
  
  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
