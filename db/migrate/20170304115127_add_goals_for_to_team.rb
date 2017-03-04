class AddGoalsForToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :goals_for, :integer
    add_column :teams, :goals_aganist, :integer
    add_column :teams, :goals_difference, :integer
    add_column :teams, :games_played, :integer
    add_column :teams, :games_won, :integer
    add_column :teams, :games_draw, :integer
    add_column :teams, :goals_lost, :integer
  end
end
