class TeamsController < ApplicationController
	
	def index
		@teams = Team.all
		render 'index'
	end

	def view_table
		@teams = Team.order(points: :desc)
		render 'table'
	end

	def new
		@team = Team.new
		render 'new'
	end

	def create
		@team = Team.new(team_params)
		@team.save
		redirect_to '/teams'
	end

	private

	def team_params
		params.require(:team).permit(:name, :stadium)
	end
end
