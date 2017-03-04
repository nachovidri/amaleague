Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	get '/games', to: 'games#index'
	get '/games/new', to: 'games#new'
	get '/games/:id', to: 'games#show', as: :game
	post '/games', to: 'games#create'

	get '/games/:id/edit', to: 'games#edit', as: :edit_game
	patch '/games/:id', to: 'games#update'

	delete '/games/:id/', to: 'games#destroy'

	get '/game/assign_points', to: 'games#assign_points', as: :assign_points

	get '/teams', to: 'teams#index'

end
