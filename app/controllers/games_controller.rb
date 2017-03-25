class GamesController < ApplicationController
	before_action :set_game, except: [:create, :new, :index]


	def index
		@fixtures = Game.order(fixture: :asc).group_by(&:fixture)
	end

	def new
		@game = Game.new
	end

	def create
		@game = Game.new(game_params)
		@game.save
		redirect_to games_path
	end

	def update
		if @game.update(game_params)
			Game.assign_points
			Game.calculate_points
			Game.calculate_goals_for
			Game.calculate_goals_against
			Game.calculate_games_played
			Game.calculate_games_won
			Game.calculate_games_lost
			Game.calculate_games_draw
			redirect_to @game
		else
			render 'edit'
		end
	end

	def destroy
		@game.destroy
		redirect_to games_path
	end

	def table
		@teams = Team.order(points: :desc)
		Game.assign_points
		Game.calculate_points
		Game.calculate_goals_for
		Game.calculate_goals_against
		Game.calculate_games_played
		Game.calculate_games_won
		Game.calculate_games_lost
		Game.calculate_games_draw
	end

	def fixture
		Game.generate_fixture
		redirect_to games_path
	end

	private

	def set_game
		@game = Game.find_by(id: params[:id])
	end

	def game_params
		params.require(:game).permit(:local_team_id, :visitor_team_id, :local_goals, :visitor_goals, :game_date_time)
	end

end
