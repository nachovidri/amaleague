class Game < ApplicationRecord
	belongs_to :local_team, class_name: "Team", foreign_key: "local_team_id"
	belongs_to :visitor_team, class_name: "Team", foreign_key: "visitor_team_id"

	def self.assign_points
		games = Game.all
		games.each do |game|
			if(game.local_goals && game.visitor_goals)
				if game.local_goals > game.visitor_goals
					game.local_points = 3
					game.visitor_points = 0
					game.save
				elsif game.local_goals < game.visitor_goals
					game.local_points = 0
					game.visitor_points = 3
					game.save
				else
					game.local_points = 1
					game.visitor_points = 1
					game.save
				end
			end
		end
	end

	def self.calculate_points
		@teams = Team.all
		points = 0
		@teams.each do |team|
			team.games_as_local.each do |game_local|
				points = points + game_local.local_points unless game_local.local_points.nil?
			end
			team.games_as_visitor.each do |game_visitor|
				points = points + game_visitor.visitor_points unless game_visitor.visitor_points.nil?
			end
			team.points = points
			team.save
		end
	end

	def self.calculate_goals_for
		@teams = Team.all
		goals_for = 0
		@teams.each do |team|
			team.games_as_local.each do |game_local|
				goals_for = goals_for + game_local.local_goals unless game_local.local_goals.nil?
			end
			team.games_as_visitor.each do |game_visitor|
				goals_for = goals_for + game_visitor.visitor_goals unless game_visitor.visitor_goals.nil?
			end
			team.goals_for = goals_for
			team.save
		end
	end
end



