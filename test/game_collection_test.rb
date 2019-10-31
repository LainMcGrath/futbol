require './test/test_helper'
require './lib/game'
require './lib/game_collection'

class GameCollectionTest < Minitest::Test
  def setup
    @game_collection = GameCollection.new("./test/data/games_sample.csv")
  end

  def test_it_exists
    assert_instance_of GameCollection, @game_collection
  end

  def test_it_can_create_games
    @game_collection.create_games("./test/data/games_sample.csv")
    expected = @game_collection.total_games.all? { |game| game.class == Game }
    assert_equal true, expected
  end

  def test_it_has_total_games
    assert_equal 20, @game_collection.total_games.length
  end

  def test_it_can_calculate_highest_total_score
    assert_equal 10, @game_collection.highest_total_score
  end

  def test_it_can_calculate_lowest_total_score
    assert_equal 0, @game_collection.lowest_total_score
  end

  def test_it_can_calculate_biggest_blowout
    assert_equal 6, @game_collection.biggest_blowout
  end

  def test_it_can_calculate_percentage_home_wins
    assert_equal 0.45, @game_collection.percentage_home_wins
  end

  def test_it_can_calculate_percentage_visitor_wins
    assert_equal 0.40, @game_collection.percentage_visitor_wins
  end

  def test_it_can_calculate_percentage_ties
    assert_equal 0.15, @game_collection.percentage_ties
  end

  def test_it_can_calculate_count_of_games_by_season
    count_games_by_season_list = {
      "20172018" => 10,
      "20152016" => 10
    }
    assert_equal count_games_by_season_list, @game_collection.count_of_games_by_season
  end

  def test_it_can_calculate_average_goals_per_game
    assert_equal 4.60, @game_collection.average_goals_per_game
  end

  def test_it_can_calculate_average_goals_by_season
    count_goals_by_season_list = {
      "20172018" => 4.10,
      "20152016" => 5.10
    }
    assert_equal count_goals_by_season_list, @game_collection.average_goals_by_season
  end
end
