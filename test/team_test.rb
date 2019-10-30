require 'csv'
require './test/test_helper'
require './lib/team'
require 'mocha/minitest'
require './lib/game_team'

class TeamsTest < Minitest::Test
  def setup
    csv = CSV.read('./test/data/game_teams_sample.csv', headers: true, header_converters: :symbol)
    all_games = csv.map do |row|
      GameTeam.new(row)
    end

    csv = CSV.read('./test/data/teams_sample.csv', headers: true, header_converters: :symbol)
    @teams = csv.map do |team|
      all_game_ids = []
      all_team_games = all_games.find_all do |game_team|
        if team[:team_id] == game_team.team_id
          all_game_ids << game_team.game_id
        end
      end
      all_opponent_games = all_game_ids.flat_map do |game_id|
        all_games.find_all do |game_team|
          game_team.game_id == game_id && game_team.team_id != team[:team_id]
        end
      end

      Team.new(team, all_team_games, all_opponent_games)
    end
    @team = @teams.first
    @team_26 = @teams.find {|team| team.team_id == "26"}
  end

  def test_it_exists
    @teams.each do |team|
      assert_instance_of Team, team
    end
  end

  def test_it_has_attributes
    assert_equal "1", @team.team_id
    assert_equal "23", @team.franchise_id
    assert_equal "Atlanta United", @team.team_name
    assert_equal "ATL", @team.abbreviation
    assert_equal "/api/v1/teams/1", @team.link
    assert_equal 14, @team.all_team_games.length
    assert_equal 14, @team.all_opponent_games.length
  end

  def test_it_has_a_win_percentage
    assert_equal 0.57, @team.win_percentage
  end

  def test_it_has_average_goals_scored_per_game
    assert_equal 2.29, @team.average_goals_scored_per_game
  end

  def test_it_has_average_goals_allowed_per_game
    assert_equal 2.21, @team.average_goals_allowed_per_game
  end

  def test_it_has_a_home_win_percentage
    assert_equal 66.67, @team.home_win_percentage
  end

  def test_it_has_an_away_win_percentage
    assert_equal 50.0, @team.away_win_percentage
  end

    def test_it_can_find_away_games_by_team
    assert_equal 4, @team_26.away_games_by_team.length
  end

  def test_away_game_goals_by_team
    assert_equal 6, @team_26.away_game_goals
  end

  def test_it_can_find_home_games_by_team
    assert_equal 8, @team_26.home_games_by_team.length
  end

  def test_it_can_find_home_goals_by_team
    assert_equal 22, @team_26.home_game_goals
  end

  def test_it_can_find_most_goals_scored_by_team
    assert_equal 7, @team_26.most_goals_scored
  end

  def test_it_can_find_fewest_goals_scored_by_team
    assert_equal 0, @team_26.fewest_goals_scored
  end

  def test_it_has_biggest_blowout
    assert_equal 4, @team_26.biggest_blowout
  end

  def test_it_has_worst_loss
    assert_equal 4, @team_26.worst_loss
  end

  def test_it_has_head_to_head
    team_names_list = {
      "1" => "Atlanta United",
      "4" => "Chicago Fire",
      "26" => "FC Cincinnati"
    }
    assert_equal ({"Chicago Fire"=>0.5, "Atlanta United"=>0.33}), @team_26.head_to_head(team_names_list)
  end
end
