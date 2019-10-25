require './test/test_helper'
require './lib/team_collection'

class TeamsCollectionTest < Minitest::Test

  def setup
    #changed this instance variable name to be consistent with other collection classes
    @team_collection = TeamCollection.new('./data/teams.csv')
  end

  def test_it_exists
    assert_instance_of TeamCollection, @team_collection
  end

  # Add test for create_teams?? This could be an argument for making this
  # a method that later assigns the teams created to the IV?

  def test_it_has_total_teams #it has total teams as an attribute?
    @team_collection.create_teams('./data/teams.csv')
    assert_equal 32, @team_collection.total_teams.length
  end

  def test_it_can_get_count_of_teams
    #this is duplicating testing the @team_collection attribute
    assert_equal 32, @team_collection.total_teams.length
  end

  
end
