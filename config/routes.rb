Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'api/v1/timers', to: 'timers#post'
  post 'api/v1/configs', to: 'configs#set'
end
