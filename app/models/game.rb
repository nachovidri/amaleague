class Game < ApplicationRecord
  belongs_to :local_team, class_name: "Team", foreign_key: "local_team_id"
  belongs_to :visitor_team, class_name: "Team", foreign_key: "visitor_team_id"

  POINTS = {win: {local_points: 3, visitor_points: 0}, loose: {local_points: 0, visitor_points: 3}, draw: {local_points: 1, visitor_points: 1}}

  validates :local_goals, :visitor_goals, numericality: { greater_than_or_equal_to: 0 }

  def assign_points
    update POINTS[:win] if local_goals > visitor_goals
    update POINTS[:loose] if local_goals < visitor_goals
    update POINTS[:draw] if local_goals == visitor_goals
  end

  def schedule
    teams = Team.all.to_a
    (0...num_teams-1).map do |r|
      t = teams.dup
      first_team = t.shift
      r.times { |i| t << t.shift }
      t = t.unshift(first_team)
      tms_away = t[0...num_teams/2]
      tms_home = t[num_teams/2...num_teams].reverse

      (0...(num_teams/2)).map do |i|
        create! local_team:tms_home[i], visitor_team: tms_away[i], fixture: r + 1, validate: false
        [tms_away[i],tms_home[i]]
      end
    end
  end

end



