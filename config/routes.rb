Rails.application.routes.draw do
  resources :articles

  devise_for :futurists, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  match '/futurists/:id/finish_signup' => 'futurists#finish_signup', via: [:get, :patch], :as => :finish_signup
  root 'home#enter_mailing_list'
end
