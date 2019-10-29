module SeasonCollection
  # inherits @games = @games_collection.total_games
  #          @teams = @teams_collection.total_teams
  # use pry -> @games & @teams to see inheritance
  def best_season(team_id)
    team = @teams.find {|team| team.team_id == team_id}
    team_games = @games.find_all do |game|
      game.away_team_id == team.team_id || game.home_team_id == team.team_id
    end
    season_list = team_games.reduce({}) do |new_list, team_game|
      if !new_list.keys.include?(team_game.season)
        new_list[team_game.season] = []
      end
      new_list[team_game.season] << team_game
      new_list
    end
    season_list.transform_values! do |season|
      x = season.count do |game|
        if team.team_id == game.away_team_id
          game.away_goals > game.home_goals
        else
          game.home_goals > game.away_goals
        end
      end
      (x.to_f / season.length).round(2)
    end
    season_list.max_by {|season| season[1]}.first
  end

  def worst_season

  end

  def seasonal_summary

  end
end
