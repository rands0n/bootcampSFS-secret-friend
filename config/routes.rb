require 'sidekiq/web'

Rails.application.routes.draw do
  resource :members, except: [:new, :edit, :show, :index, ]
  resource :campaigns, except: [:new, :edit]

  get 'pages/home'

  devise_for :users,
    :controllers => { registrations: 'registrations' },
    :path => '',
    :path_names => {
      :sign_in => 'login',
      :sign_out => 'logout',
      :sign_up => 'signup'
    }

  mount Sidekiq::Web => '/sidekiq'
end
