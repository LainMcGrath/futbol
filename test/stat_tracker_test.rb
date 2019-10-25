require './test/test_helper'
require './lib/stat_tracker'
require './lib/game_collection'
require './lib/team_collection'
require './lib/game_team_collection'

class StatTrackerTest < Minitest::Test
  def setup
    game_path = './data/games_sample.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_it_exists
    stat_tracker = StatTracker.new('./data/games_sample.csv', './data/teams.csv', './data/game_teams.csv')
    assert_instance_of StatTracker, stat_tracker
  end

  def test_it_can_be_created_from_csv
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_has_attributes
    assert_instance_of GameCollection, @stat_tracker.game_collection
    assert_instance_of TeamCollection, @stat_tracker.team_collection
    assert_instance_of GameTeamCollection, @stat_tracker.game_team_collection
  end

  def test_it_can_calculate_highest_total_score
    assert_equal 5, @stat_tracker.game_collection.highest_total_score
  end

end
