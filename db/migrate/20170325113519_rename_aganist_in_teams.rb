class RenameagainstInTeams < ActiveRecord::Migration[5.0]
  def change
  	rename_column :teams, :goals_aganist, :goals_against
  	rename_column :teams, :goals_lost, :games_lost
  end
end
