require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'pages#home'

  mount Sidekiq::Web => '/sidekiq'

  resource :members, only: [:create, :destroy, :update]

  resource :campaigns, except: [:new] do
    post 'raffle', on: :member
  end

  get 'members/:token/opened', to: 'members#opened'

  devise_for :users,
    :controllers => { registrations: 'registrations' },
    :path => '',
    :path_names => {
      :sign_in => 'login',
      :sign_out => 'logout',
      :sign_up => 'signup'
    }
end
