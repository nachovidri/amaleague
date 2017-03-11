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

	def self.generate_fixture_dummy
		teams = Team.all
		num_teams = teams.count
		fixtures = teams.each_slice(2)
		fixture_n = 1
		for i in 1..num_teams*2-2
			fixtures.each do |fixture|
				if fixture.count == 2
					game = Game.new
					game.local_team = fixture[0]
					game.visitor_team = fixture[1]
					game.fixture = fixture_n
					game.save
				else
					not_playing = fixture[0].name
				end
				
			end
			fixture_n += 1
		end
	end

	def self.generate_fixture
		Game.destroy_all
		teams = Team.all.to_a

		if teams.count%2 == 1
			dummy_team = Team.new
			dummy_team.id = -1
			teams << dummy_team
		end

		teams = teams.shuffle
		num_teams = teams.count

		fixture_ini = teams.each_slice(2).to_a
		num_fixtures = num_teams*2-2
		num_games = fixture_ini.count
		fixture_n = 1
		aux = []

		for i in 1..num_fixtures
			fixture_ini.each do |team|
				if fixture_n <= (num_fixtures/2)
					if (team[0].id != -1 && team[1].id != -1) 
						game = Game.new
						game.local_team = team[0]
						game.visitor_team = team[1]
						game.fixture = fixture_n
						game.save
					elsif (team[0] != -1)
						not_playing = team[0]
					else
						not_playing = team[1]
					end
				else
					if (team[0].id != -1 && team[1].id != -1) 
						game = Game.new
						game.local_team = team[1]
						game.visitor_team = team[0]
						game.fixture = fixture_n
						game.save
					elsif (team[0] != -1)
						not_playing = team[0]
					else
						not_playing = team[1]
					end
				end
			end
			
			aux = fixture_ini.inject([]){|a, element| a << element.dup}

			for i in 0..(num_games-1)
				if i == 0
					# fixture_ini[0][0] = fixture_ini[0][0]
					aux[0][1] = fixture_ini[1][0]
				elsif i == (num_games-1)
					aux[num_games-1][0] = fixture_ini[num_games-1][1]
					aux[num_games-1][1] = fixture_ini[num_games-2][1]
				else
					aux[i][0] = fixture_ini[i+1][0]
					aux[i][1] = fixture_ini[i-1][1]
				end
			end
			
			fixture_ini = aux.inject([]){|a, element| a << element.dup}

			fixture_n += 1
			
		end
	end
end



