class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @fixtures = Game.order(fixture: :asc).group_by(&:fixture)
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        @game.assign_points
        @game.visitor_team.calculate_points
        @game.local_team.calculate_points

        format.html { redirect_to games_path, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def table
    @teams = Team.order(points: :desc, goals_for: :desc, goals_against: :asc)
  end

  def fixture
    Game.schedule
    redirect_to games_path, notice: "Your League is ready to start!"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:local_goals, :visitor_goals)
    end
end