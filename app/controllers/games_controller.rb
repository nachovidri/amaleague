class GamesController < ApplicationController

	def index
		@games = Game.order(game_date_time: :desc)
		render 'index'
	end

	def show
		game
	end

	def new
		@game = Game.new
		render 'new'
	end

	def create
		@game = Game.new(game_params)
		@game.save
		redirect_to '/games'
	end

	def edit
		game
	end

	def update
		if game.update(game_params)
			redirect_to game_path @game
		else
			render 'edit'
		end
	end

	def destroy
		game.destroy
		redirect_to '/games'
	end

	def assign_points
		Game.assign_points
		Game.calculate_points
		redirect_to '/teams'
	end

	private

	def game
		@game = Game.find_by(id: params[:id])
	end

	def game_params
		params.require(:game).permit(:local_team_id, :visitor_team_id, :game_date_time)
	end

end
