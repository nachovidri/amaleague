# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170304141450) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "local_team_id"
    t.integer  "visitor_team_id"
    t.integer  "local_goals"
    t.integer  "visitor_goals"
    t.datetime "game_date_time"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "local_points"
    t.integer  "visitor_points"
    t.integer  "fixture"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "stadium"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "points"
    t.integer  "goals_for"
    t.integer  "goals_aganist"
    t.integer  "goals_difference"
    t.integer  "games_played"
    t.integer  "games_won"
    t.integer  "games_draw"
    t.integer  "goals_lost"
  end

end
