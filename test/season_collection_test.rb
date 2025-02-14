require './test/test_helper'
require './lib/season_collection.rb'
require './lib/stat_tracker.rb'
require './lib/game_collection.rb'
require './lib/team_collection.rb'

class SeasonCollectionTest < Minitest::Test
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

    @team_26 = @teams.find {|team| team.team_id == "26"}
    @team_26_games = @games.find_all do |game|
      game.away_team_id == "26" || game.home_team_id == "26"
    end
    @team_26_post_season_games = @team_26_games.find_all {|game| game.season == "20172018" && game.type == "Postseason"}
    @team_26_regular_season_games = @team_26_games.find_all {|game| game.season == "20172018" && game.type == "Regular Season"}
  end

  def test_it_has_best_season
    assert_equal "20152016", @stat_tracker.best_season("26")
  end

  def test_it_has_worst_season
    assert_equal "20172018", @stat_tracker.worst_season("26")
  end

  def test_it_has_seasonal_summary
    expected_hash = {
      "20172018" => {:postseason =>
                      {
                        :win_percentage=>0.5,
                        :total_goals_scored=>4,
                        :total_goals_against=>5,
                        :average_goals_scored=>2.0,
                        :average_goals_against=>2.5
                      },
                    :regular_season =>
                      {
                        :win_percentage=>0.25,
                        :total_goals_scored=>6,
                        :total_goals_against=>9,
                        :average_goals_scored=>1.5,
                        :average_goals_against=>2.25
                      }},
      "20152016" => {:postseason =>
                      {
                        :win_percentage=>0.5,
                        :total_goals_scored=>4,
                        :total_goals_against=>4,
                        :average_goals_scored=>2.0,
                        :average_goals_against=>2.0
                      },
                     :regular_season =>
                      {
                        :win_percentage=>0.5,
                        :total_goals_scored=>14,
                        :total_goals_against=>10,
                        :average_goals_scored=>3.5,
                        :average_goals_against=>2.5}
                      }}
    assert_equal expected_hash, @stat_tracker.seasonal_summary("26")
  end

  def test_it_has_a_win_percentage
    assert_equal 0.5, @stat_tracker.win_percentage("26", @team_26_post_season_games)
  end

  def test_it_has_total_goals_scored
    assert_equal 4, @stat_tracker.total_goals_scored("26", @team_26_post_season_games)
  end

  def test_it_has_total_goals_against
    assert_equal 5, @stat_tracker.total_goals_against("26", @team_26_post_season_games)
  end

  def test_it_has_average_goals_scored
    assert_equal 2.0, @stat_tracker.average_goals_scored("26", @team_26_post_season_games)
  end

  def test_it_has_average_goals_against
    assert_equal 2.5, @stat_tracker.average_goals_against("26", @team_26_post_season_games)
  end

  def test_it_can_find_best_coach
    assert_equal "Dave Hakstol", @stat_tracker.winningest_coach("20172018")
  end

  def test_it_can_find_worst_coach
    assert_equal "John Hynes", @stat_tracker.worst_coach("20172018")
  end

  def test_it_has_biggest_bust
    assert_equal "Atlanta United", @stat_tracker.biggest_bust("20172018")
  end

  def test_it_has_biggest_surprise
    assert_equal "FC Cincinnati", @stat_tracker.biggest_surprise("20172018")
  end

  def test_it_can_get_games_from_season
    assert_equal 10, @stat_tracker.games_from_season("20172018").length
    assert_equal 0, @stat_tracker.games_from_season("20132014").length
  end

  def test_it_can_get_team_ids_from_season
    assert_equal ["1", "4", "26"], @stat_tracker.team_ids_from_season("20172018")
    assert_equal [], @stat_tracker.team_ids_from_season("20132014")
  end

  def test_it_list_difference_between_regular_and_postseason_win_percentage_by_team_id
    assert_equal -0.25, @stat_tracker.difference_between_reg_post_win_percentage("26", "20172018")
  end

  def test_it_has_most_accurate_team
    assert_equal "Chicago Fire", @stat_tracker.most_accurate_team("20172018")
  end

  def test_it_has_least_accurate_team
    assert_equal "Atlanta United", @stat_tracker.least_accurate_team("20172018")
  end

  def test_it_has_name_of_team_with_most_tackles
    assert_equal "Chicago Fire", @stat_tracker.most_tackles("20172018")
  end

  def test_it_has_name_of_team_with_least_tackles
    assert_equal "Atlanta United", @stat_tracker.fewest_tackles("20172018")
  end
end
