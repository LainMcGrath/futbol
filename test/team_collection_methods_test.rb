require './test/test_helper'
require './lib/team_collection'

class TeamCollectionMethodsTest < MiniTest::Test
  def setup
    @total_teams = TeamCollection.new("./test/data/teams_sample.csv", "./test/data/game_teams_sample.csv")
  end

  def test_it_has_the_best_offense
    assert_equal "FC Cincinnati", @total_teams.best_offense
  end

  def test_it_has_the_worst_offense
    assert_equal "Atlanta United", @total_teams.worst_offense
  end

  def test_it_has_the_best_defense
    assert_equal "Atlanta United", @total_teams.best_defense
  end

  def test_it_has_the_worst_defense
    assert_equal "Chicago Fire", @total_teams.worst_defense
  end

  def test_it_has_winningest_team
    assert_equal "Atlanta United", @total_teams.winningest_team
  end

  def test_it_has_best_fans
    assert_equal "FC Cincinnati", @total_teams.best_fans
  end

  def test_it_has_worst_fans
    assert_equal ["Chicago Fire"], @total_teams.worst_fans
  end

  def test_it_can_find_highest_away_average
    assert_equal "Chicago Fire", @total_teams.highest_scoring_visitor
  end

  def test_it_can_find_highest_home_average
    assert_equal "FC Cincinnati", @total_teams.highest_scoring_home_team
  end

  def test_it_can_find_the_lowest_scoring_visitor
    assert_equal "FC Cincinnati", @total_teams.lowest_scoring_visitor
  end

  def test_it_can_find_the_lowest_scoring_home_team
    assert_equal "Chicago Fire", @total_teams.lowest_scoring_home_team
  end

  def test_it_can_create_team_info
    team_information = {"team_id"=>"26", "franchise_id" =>"14", "team_name"=>"FC Cincinnati",
                        "abbreviation"=>"CIN", "link"=>"/api/v1/teams/26"}
    assert_equal team_information, @total_teams.team_info("26")
  end

  def test_it_can_find_all_teams_games
    assert_equal (12), @total_teams.all_team_games("26")
  end

  def test_it_can_find_all_won_games
    assert_equal (5), @total_teams.all_won_games("26")
  end

  def test_it_can_find_average_win_percentage
    assert_equal 0.42, @total_teams.average_win_percentage("26")
  end

  def test_it_can_find_most_goals_scored_by_team
    assert_equal 7, @total_teams.most_goals_scored("26")
  end

  def test_it_can_find_fewest_goals_scored_by_team
    assert_equal 0, @total_teams.fewest_goals_scored("26")
  end

  def test_it_can_find_favorite_opponent_by_team
    assert_equal "Chicago Fire", @total_teams.favorite_opponent("26")
  end

  def test_it_can_find_rival_by_team
    assert_equal "Atlanta United", @total_teams.rival("26")
  end

  def test_it_has_biggest_team_blowout
    assert_equal 4, @total_teams.biggest_team_blowout("26")
  end

  def test_it_has_worst_loss
    assert_equal 4, @total_teams.worst_loss("26")
  end

  def test_it_has_head_to_head
    assert_equal ({"Chicago Fire"=>0.5, "Atlanta United"=>0.33}), @total_teams.head_to_head("26")
  end
end
