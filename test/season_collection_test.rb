require './test/test_helper'
require './lib/season_collection.rb'
require './lib/stat_tracker.rb'
require './lib/game_collection.rb'
require './lib/team_collection.rb'

class SeasonCollectionTest < MiniTest::Test
  def setup
    game_path = './test/data/games_sample.csv'
    team_path = './test/data/teams_sample.csv'
    game_teams_path = './test/data/game_teams_sample.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    games_collection = GameCollection.new(game_path)
    teams_collection = TeamCollection.new(team_path, game_teams_path)
    @games = games_collection.total_games
    @teams = teams_collection.total_teams
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_it_has_best_season
    assert_equal "20152016", @stat_tracker.best_season("26")
  end

  def test_it_has_worst_season
    assert_equal "20152016", @stat_tracker.worst_season("26")
  end

  def test_it_has_seasonal_summary
    skip
    assert_equal "ha ha", @stat_tracker.seasonal_summary("26")
  end
end
