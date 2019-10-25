require './test/test_helper'
require './lib/game_team_collection'

class GameTeamCollectionTest < Minitest::Test

  def setup
    @game_team_collection = GameTeamCollection.new("./data/game_teams_sample.csv")
  end

  def test_it_exists
    assert_instance_of GameTeamCollection, @game_team_collection
  end

  #test create_game_teams?

  def test_it_has_total_game_team
    @game_team_collection.create_game_teams("./data/game_teams_sample.csv")
    assert_equal 50, @game_team_collection.total_game_teams.length
  end

  def test_it_can_find_all_team_ids
    assert_equal 
  end

end
