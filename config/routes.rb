Diffux::Application.routes.draw do
  get 'static_pages/about'

  resources :projects do
    resources :sweeps, only: %i[index show new create]
  end
  resources :urls, only: %i[destroy]

  resources :snapshots, only: %i[show create destroy] do
    member do
      post :accept
      post :reject
    end
  end

  resources :sessions, only: [] do
    collection do
      delete :logout
    end
  end

  # n.b.: this route is for the helper only, as any request to it is intercepted
  # by Omniauth middleware before Rails gets it:
  get 'auth/google_oauth2', as: :google_oauth2

  get 'auth/google_oauth2/callback', to: 'user_auth_callbacks#google_oauth2'

  root to: 'projects#index'
end
