class TeamsController < ApplicationController
	def index
		@teams = Team.order(points: :desc)
		render 'index'
	end
end
