class GamesController < ApplicationController

	def index
		@games = Game.order(fixture: :asc)
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

	def view_table
		@teams = Team.all
		Game.assign_points
		Game.calculate_points
		Game.calculate_goals_for
		render '/teams/table'
	end

	def generate_fixture
		# Game.generate_fixture_dummy
		Game.generate_fixture
		redirect_to '/games'
	end

	private

	def game
		@game = Game.find_by(id: params[:id])
	end

	def game_params
		params.require(:game).permit(:local_team_id, :visitor_team_id, :local_goals, :visitor_goals, :game_date_time)
	end

end
