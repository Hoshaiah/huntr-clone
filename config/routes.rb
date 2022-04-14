Rails.application.routes.draw do
  get 'cards/new'
  get 'cards/edit'
  resources :kanbans do
    resources :kanban_columns do
      resources :cards do
        resources :activities 
      end
    end
  end

  devise_for :users
  root to: 'pages#home'
  patch '/kanbans/:id/sort', to: 'kanbans#sort', as: "kanban_sort"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
