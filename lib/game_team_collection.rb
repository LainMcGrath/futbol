require 'csv'
require_relative './game_team.rb'

class GameTeamCollection
  attr_reader :total_game_teams

  def initialize(game_team_path)
    @total_game_teams = create_game_teams(game_team_path)
  end

  def create_game_teams(game_team_path)
    csv = CSV.read(game_team_path, headers: true, header_converters: :symbol)
    csv.map do |row|
      GameTeam.new(row)
    end
  end
end
