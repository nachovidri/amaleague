class Game < ApplicationRecord
	belongs_to :local_team, class_name: "Team", foreign_key: "local_team_id"
	belongs_to :visitor_team, class_name: "Team", foreign_key: "visitor_team_id"

	POINTS = {win: 3, loose: 0, draw: 1}

	def self.assign_points
		games = Game.all
		games.each do |game|
			next unless game.local_goals && game.visitor_goals
			
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

	def self.calculate_points
		Team.all.each do |team|
			local_points = team.games_as_local.sum(:local_points)
			visitor_points = team.games_as_visitor.sum(:visitor_points)
			team.update points: local_points + visitor_points
		end
	end

	def self.calculate_goals_for
		Team.all.each do |team|
			local_goals = team.games_as_local.sum(:local_goals)
			visitor_goals = team.games_as_visitor.sum(:visitor_goals)
			team.update goals_for: local_goals + visitor_goals
		end
	end

	def self.calculate_goals_against
		Team.all.each do |team|
			local_goals = team.games_as_local.sum(:visitor_goals)
			visitor_goals = team.games_as_visitor.sum(:local_goals)
			team.update goals_against: local_goals + visitor_goals
		end
	end

	def self.calculate_games_played
		Team.all.each do |team|
			local_goals = team.games_as_local.where.not(local_goals: nil).count
			visitor_goals = team.games_as_visitor.where.not(visitor_goals: nil).count
			team.update! games_played: local_goals + visitor_goals
		end
	end

	def self.calculate_games_won
		Team.all.each do |team|
			local_wins = team.games_as_local.where("local_goals > visitor_goals").count
			visitor_wins = team.games_as_visitor.where("local_goals < visitor_goals").count
			team.update! games_won: local_wins + visitor_wins
		end
	end

	def self.calculate_games_lost
		Team.all.each do |team|
			local_losts = team.games_as_local.where("local_goals < visitor_goals").count
			visitor_losts = team.games_as_visitor.where("local_goals > visitor_goals").count
			team.update! games_lost: local_losts + visitor_losts
		end
	end

	def self.calculate_games_draw
		Team.all.each do |team|
			local_draws = team.games_as_local.where("local_goals = visitor_goals").count
			visitor_draws = team.games_as_visitor.where("local_goals = visitor_goals").count
			team.update! games_draw: local_draws + visitor_draws
		end
	end

	def self.generate_fixture_self_algorithm

		Game.destroy_all
		teams = Team.all

		games = []

		teams.each do |team|
			rest_of_teams = teams - [team]
			rest_of_teams.each do |team2|
				possible_game = [team.id, team2.id]
				next if games.include?(possible_game) || games.include?(possible_game.reverse)
				game = Game.create(local_team: team, visitor_team: team2) 
				games << [team.id, team2.id]
			end
		end

		recursive_fixtures(games)
		games
	end


	def self.recursive_fixtures(games, fixture = 1, fixtures = [])
		game = games.find { |g| g.all? { |g2| !g2.in?(fixtures.flatten) } }

		if game
			Game.find_by(local_team_id: game.first, visitor_team_id: game.last).update!(fixture: fixture)
			games.delete(game)
			fixtures << game
			recursive_fixtures(games, fixture, fixtures)
		else
			fixture += 1
			#binding.pry
			recursive_fixtures(games, fixture, []) unless games.size.zero?
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



