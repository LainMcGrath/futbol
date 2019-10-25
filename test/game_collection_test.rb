require './test/test_helper'
require './lib/game'
require './lib/game_collection'

class GameCollectionTest < Minitest::Test

  def setup
    @game_collection = GameCollection.new("./data/games_sample.csv")
  end

  def test_it_exists
    assert_instance_of GameCollection, @game_collection
  end

  def test_it_has_total_games #this is really like test it has an attribute of total games?
    @game_collection.create_games('./data/games_sample.csv')
    assert_equal 8, @game_collection.total_games.length
  end

  #I think we need another method here to test create_games
  def test_it_can_create_games
    #wow how do we test this when we use it in initialize? 
  end

  def test_it_can_calculate_highest_total_score
    assert_equal 5, @game_collection.highest_total_score
  end

  def test_it_can_calculate_lowest_total_score
    assert_equal 2, @game_collection.lowest_total_score
  end

  def test_it_can_calculate_biggest_blowout
    assert_equal 2, @game_collection.biggest_blowout
  end

  def test_it_can_calculate_percentage_home_wins
    assert_equal 25.00, @game_collection.percentage_home_wins
  end

  def test_it_can_calculate_percentage_visitor_wins
    assert_equal 50.00, @game_collection.percentage_visitor_wins
  end

  def test_it_can_calculate_percentage_ties
    assert_equal (2/8.0).round(2), @game_collection.percentage_ties
  end

  def test_it_can_calculate_count_of_games_by_season
    count_games_by_season_list = {
      20122013 => 5,
      20142015 => 3
    }
    assert_equal count_games_by_season_list, @game_collection.count_of_games_by_season
  end

  def test_it_can_calculate_average_goals_per_game
    #(31 total goals / 8 games)
    assert_equal (31/8.0).round(2), @game_collection.average_goals_per_game
  end

  def test_it_can_calculate_average_goals_by_season
    # 2012/2013 19 goals / 5 games
    # 2014/2015 12 goals / 3 games
    count_goals_by_season_list = {
      20122013 => (19/5.0).round(2),
      20142015 => (12/3.0).round(2)
    }
    assert_equal count_goals_by_season_list, @game_collection.average_goals_by_season
  end
end
