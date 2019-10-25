require './lib/game_collection'
require './lib/team_collection'
require './lib/game_team_collection'

class StatTracker
  attr_reader :game_collection, :team_collection, :game_team_collection

  def initialize(game_path, team_path, game_teams_path)
    @game_collection = GameCollection.new(game_path) #should we move the creation of GameCollection instance into a method
    @team_collection = TeamCollection.new(team_path)
    @game_team_collection = GameTeamCollection.new(game_teams_path)

  end

  def self.from_csv(locations)
    game_path = locations[:games]
    team_path = locations[:teams]
    game_teams_path = locations[:game_teams]

    self.new(game_path, team_path, game_teams_path)
  end

  def highest_total_score
    @game_collection.highest_total_score
  end
end
