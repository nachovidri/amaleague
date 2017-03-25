class Team < ApplicationRecord
	has_many :games_as_local, class_name: "Game", foreign_key: "local_team_id"
	has_many :games_as_visitor, class_name: "Game", foreign_key: "visitor_team_id"

	def calculate_points
		local = games_as_local
		visitor = games_as_visitor

		points = local.sum(:local_points) + visitor.sum(:visitor_points)
		goals_for = local.sum(:local_goals) + visitor.sum(:visitor_goals)
		goals_against = local.sum(:visitor_goals) + visitor.sum(:local_goals)
		games_played = local.where.not(local_goals: nil).count + visitor.where.not(visitor_goals: nil).count
		games_won = local.where("local_goals > visitor_goals").count + visitor.where("local_goals < visitor_goals").count
		games_lost = local.where("local_goals < visitor_goals").count + visitor.where("local_goals > visitor_goals").count
		games_draw = local.where("local_goals = visitor_goals").count + visitor.where("local_goals = visitor_goals").count

		update points: points, goals_for: goals_for, goals_against: goals_against, games_played: games_played, games_won: games_won, games_lost: games_lost, games_draw: games_draw
	end


end
