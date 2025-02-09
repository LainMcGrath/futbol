require 'csv'
require './test/test_helper'
require './lib/game_team'

class GameTeamTest < Minitest::Test
  def setup
    csv = CSV.read('./test/data/game_teams_sample.csv', headers: true, header_converters: :symbol)
    @game_teams = csv.map do |row|
      GameTeam.new(row)
    end
  end

  def test_it_exists
    @game_teams.each do |row|
      assert_instance_of GameTeam, row
    end
  end

  def test_it_has_attributes
    game_team = @game_teams.first
    assert_equal "2017030110", game_team.game_id
    assert_equal "4", game_team.team_id
    assert_equal "away", game_team.hoa
    assert_equal "LOSS", game_team.result
    assert_equal "REG", game_team.settled_in
    assert_equal "Dave Hakstol", game_team.head_coach
    assert_equal 2, game_team.goals
    assert_equal 8, game_team.shots
    assert_equal 45, game_team.tackles
    assert_equal 53, game_team.pim
    assert_equal 5, game_team.powerplayopportunities
    assert_equal 0, game_team.powerplaygoals
    assert_equal 55.9, game_team.faceoffwinpercentage
    assert_equal 17, game_team.giveaways
    assert_equal 2, game_team.takeaways
  end
end
