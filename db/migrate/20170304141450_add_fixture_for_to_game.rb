class AddFixtureForToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :fixture, :integer
  end
end
