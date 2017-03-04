class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
    	t.integer :local_team_id
    	t.integer :visitor_team_id
    	t.integer :local_goals
    	t.integer :visitor_goals
    	t.datetime :game_date_time

      t.timestamps
    end
  end
end

      