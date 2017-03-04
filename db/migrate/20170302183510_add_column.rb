class AddColumn < ActiveRecord::Migration[5.0]
  def change
  	add_column :games, :local_points, :integer
  	add_column :games, :visitor_points, :integer
  end
end
