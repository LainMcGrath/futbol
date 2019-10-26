require 'csv'
require './lib/team'
require './lib/game'
require './lib/game_team'
require './lib/game_team_collection'
require './lib/team_collection'
require './lib/game_collection'

game_team_collection = GameTeamCollection.new("./data/game_teams_sample.csv")
@total_game_teams = game_team_collection.total_game_teams
team_collection = TeamCollection.new("./data/teams.csv")
@total_teams = team_collection.total_teams
game_collection = GameCollection.new('./data/games_sample.csv')
@total_games = game_collection.total_games

# this is using game_team
def find_game_team_by_team_id(id) #helpful b/c you'll only look at teams that are acutally in our sample data
  @total_game_teams.find_all { |game_team| game_team.team_id == id }
end

def lifetime_goals_by_team_id(id)
  lifetime_games = find_game_team_by_team_id(id)
  lifetime_games.sum { |game| game.goals }
end

def average_lifetime_goals_per_game(id)
  lifetime_goals_by_team_id(id).to_f / find_game_team_by_team_id(id).length
end

def unique_game_id_in_game_teams
  @total_game_teams.map { |gt| gt.team_id }.uniq
end

def average_goals_lifetime_by_game_id
  unique_game_id_in_game_teams.reduce({}) do |hash, id|
    hash[id] = average_lifetime_goals_per_game(id)
    hash
  end
end

def best_offense_by_team_id
  average_goals_lifetime_by_game_id.max_by { |k,v| v}.first
end

def worst_offense_by_team_id
  average_goals_lifetime_by_game_id.min_by { |k,v| v}.first
end

def best_offense #method 2, iteration 3, return value is a team name string
  @total_teams.find { |team| team.team_id == best_offense_by_team_id }.team_name
end

def worst_offense #method 3, iteration 3, return value is a team name string
  @total_teams.find { |team| team.team_id == worst_offense_by_team_id }.team_name
end

#using games.csv
def find_home_games_by_id(id)
  @total_games.find_all do |game|
    game.home_team_id == id
  end
end

#this is using games.csv
def sum_lifetime_visitor_goals_by_id(id)
  find_home_games_by_id(id).sum { |game| game.away_goals }
end #so this team has had X number of goals scored against them ever

def average_lifetime_visitor_goals_by_id(id)
  average(sum_lifetime_visitor_goals_by_id(id), find_home_games_by_id(id).length)
end

def get_array_of_team_ids #using teams collection
  @total_teams.map { |team| team.team_id }
end #array of all team ids

#generic helper method, not rounded to any specific number of decimals
def average(sum, total_occurances)
    if total_occurances.to_f == 0
      0
    else
      sum / total_occurances.to_f
    end
end

def get_hash_of_away_goals_scored_on_a_home_team
  get_array_of_team_ids.reduce({}) do |hash, team_id|
    hash[team_id] = average_lifetime_visitor_goals_by_id(team_id)
    hash
  end
end

def best_defense_by_team_id #having a problem w/ divide by zero? google when internet
  get_hash_of_away_goals_scored_on_a_home_team.min_by{ |k,v| v }
  #having problems w/ games data set b/c not every time is in it, so most teams are showing they have 0 goals against them
end

def worse_defense_by_team_id
  #add this in but should be line 89 with max by (MOST average goals scored by away team )
end

##helping Laine

#find gt where the team is away by the team id
# all_away_games = @total_game_teams.find_all { |gt| gt.team_id == 3 && gt.hoa == "away" }
# all_goals_when_away = all_away_games.sum { |gt| gt.goals }
# averge = all_goals_when_away / all_away_games.length.to_f
# iterate over all the team ids that are available in the game_team file and perform the above methods


require "pry"; binding.pry
