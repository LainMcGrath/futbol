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
      wins = season.count do |game|
        if team.team_id == game.away_team_id
          game.away_goals > game.home_goals
        else
          game.home_goals > game.away_goals
        end
      end
      (wins.to_f / season.length).round(2)
    end

    season_list.max_by {|season| season[1]}.first
  end

  def worst_season(team_id)
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
      wins = season.count do |game|
        if team.team_id == game.away_team_id
          game.away_goals > game.home_goals
        else
          game.home_goals > game.away_goals
        end
      end
      (wins.to_f / season.length).round(2)
    end
    season_list.min_by {|season| season[1]}.first
  end

  def seasonal_summary(team_id)
    team = @teams.find {|team| team.team_id == team_id}
    team_games = @games.find_all do |game|
      game.away_team_id == team.team_id || game.home_team_id == team.team_id
    end
    season_list = team_games.reduce({}) do |new_list, team_game|
      post_season_games = team_games.find_all {|game| game.season == team_game.season && game.type == "Postseason"}
      regular_season_games = team_games.find_all {|game| game.season == team_game.season && game.type == "Regular Season"}
      new_list[team_game.season] = {
        :postseason => {
          win_percentage: win_percentage(team.team_id, post_season_games),
          total_goals_scored: total_goals_scored(team.team_id, post_season_games),
          total_goals_against: total_goals_against(team.team_id, post_season_games),
          average_goals_scored: average_goals_scored(team.team_id, post_season_games),
          average_goals_against: average_goals_against(team.team_id, post_season_games)
        },
        :regular_season => {
          win_percentage: win_percentage(team.team_id, regular_season_games),
          total_goals_scored: total_goals_scored(team.team_id, regular_season_games),
          total_goals_against: total_goals_against(team.team_id, regular_season_games),
          average_goals_scored: average_goals_scored(team.team_id, regular_season_games),
          average_goals_against: average_goals_against(team.team_id, regular_season_games)
        }
      }
      new_list
    end
  end

  def win_percentage(team_id, games)
    return 0.0 if games.length == 0
    wins = 0
    wins = games.count do |game|
      if team_id == game.away_team_id
        game.away_goals > game.home_goals
      else
        game.home_goals > game.away_goals
      end
    end
    (wins.to_f / games.length).round(2)
  end

  def total_goals_scored(team_id, games)
    goals = 0
    games.each do |game|
      if team_id == game.away_team_id
        goals += game.away_goals
      else
        goals += game.home_goals
      end
    end
    return goals
  end

  def total_goals_against(team_id, games)
    goals = 0
    games.each do |game|
      if team_id == game.away_team_id
        goals += game.home_goals
      else
        goals += game.away_goals
      end
    end
    return goals
  end

  def average_goals_scored(team_id, games)
    return 0.0 if games.length == 0
    average = (total_goals_scored(team_id, games).to_f / games.length).round(2)
  end

  def average_goals_against(team_id, games)
    return 0.0 if games.length == 0
    (total_goals_against(team_id, games).to_f / games.length).round(2)
  end

  def biggest_bust(season_id)
    # season_id = "20172018"
    team_ids = @teams.map do |team|
      team.team_id
    end

    hash = team_ids.reduce({}) do |hash, team_id|
      ss = seasonal_summary(team_id)[season_id]
      reg = ss[:regular_season][:win_percentage]
      require "pry"; binding.pry
      post = ss[:postseason][:win_percentage]
      difference = reg - post

      hash[team_id] = difference
      hash
    end
    team_id = hash.max_by { |k,v| v }.first
    @teams.find { |team| team.team_id == team_id }.team_name
  end

  def biggest_surprise(season_id)
    team_ids = @teams.map do |team|
      team.team_id
    end

    hash = team_ids.reduce({}) do |hash, team_id|
      ss = seasonal_summary(team_id)[season_id]
      reg = ss[:regular_season][:win_percentage]
      post = ss[:postseason][:win_percentage]
      difference = reg - post

      hash[team_id] = difference
      hash
    end
    team_id = hash.min_by { |k,v| v }.first
    @teams.find { |team| team.team_id == team_id }.team_name
  end
end
