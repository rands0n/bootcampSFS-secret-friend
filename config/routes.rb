require 'sidekiq/web'

Rails.application.routes.draw do
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
