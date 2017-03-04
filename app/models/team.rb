class Team < ApplicationRecord
	has_many :games_as_local, class_name: "Game", foreign_key: "local_team_id"
	has_many :games_as_visitor, class_name: "Game", foreign_key: "visitor_team_id"
end
