Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	get '/leagues', to: 'leagues#index', as: :leagues


	get '/games', to: 'games#index'
	get '/games/new', to: 'games#new'
	get '/games/fixture', to: 'games#generate_fixture', as: :fixture
	
	get '/games/view_table', to: 'games#view_table', as: :view_table
	get '/games/:id', to: 'games#show', as: :game

	post '/games', to: 'games#create'

	get '/games/:id/edit', to: 'games#edit', as: :edit_game
	patch '/games/:id', to: 'games#update'

	delete '/games/:id/', to: 'games#destroy'

	


	get '/teams', to: 'teams#index'

	get '/teams/new', to: 'teams#new', as: :new_team
	post '/teams', to: 'teams#create'

end
