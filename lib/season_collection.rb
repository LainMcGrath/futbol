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
    team_ids = team_ids_from_season(season_id)
    differences_by_team = team_ids.reduce({}) do |differences_by_team, team_id|
      differences_by_team[team_id] = difference_between_reg_post_win_percentage(team_id, season_id)
      differences_by_team
    end
    team_id = differences_by_team.max_by { |k,v| v }.first
    @teams.find { |team| team.team_id == team_id }.team_name
  end

  def biggest_surprise(season_id)
    team_ids = team_ids_from_season(season_id)
    differences_by_team = team_ids.reduce({}) do |differences_by_team, team_id|
      differences_by_team[team_id] = difference_between_reg_post_win_percentage(team_id, season_id)
      differences_by_team
    end
    team_id = differences_by_team.min_by { |k,v| v }.first
    @teams.find { |team| team.team_id == team_id }.team_name
  end

  def games_from_season(season_id)
    @games.find_all { |game| game.season == season_id }
  end

  def team_ids_from_season(season_id)
    season_games = games_from_season(season_id)
    home_team_ids = season_games.map { |game| game.home_team_id }.uniq
    away_team_ids = season_games.map { |game| game.away_team_id }.uniq
    team_ids = (home_team_ids + away_team_ids).uniq
  end

  def difference_between_reg_post_win_percentage(team_id, season_id)
    summary = seasonal_summary(team_id)[season_id]
    reg = summary[:regular_season][:win_percentage]
    post = summary[:postseason][:win_percentage]
    difference = reg - post
  end

  def most_accurate_team(season_id)
    team_ids = team_ids_from_season(season_id)

    team_shot_percentage_list = team_ids.reduce({}) do |team_shot_percentage_list, team_id|
      team = @teams.find { |team| team.team_id == team_id }
      season_id_four = season_id[0..3]
      season_games = team.all_team_games.find_all { |game| game.game_id.start_with?(season_id_four) }
      season_goals = season_games.sum { |game| game.goals}
      season_shots = season_games.sum { |game| game.shots}
      team_shot_percentage_list[team_id] = (season_goals.to_f / season_shots).round(6)
      team_shot_percentage_list
    end
    team_id = team_shot_percentage_list.max_by { |team_id, shot_percentage| shot_percentage }.first
    @teams.find { |team| team.team_id == team_id }.team_name
  end

  def least_accurate_team(season_id)
    team_ids = team_ids_from_season(season_id)

    team_shot_percentage_list = team_ids.reduce({}) do |team_shot_percentage_list, team_id|
      team = @teams.find { |team| team.team_id == team_id }
      season_id_four = season_id[0..3]
      season_games = team.all_team_games.find_all { |game| game.game_id.start_with?(season_id_four) }
      season_goals = season_games.sum { |game| game.goals}
      season_shots = season_games.sum { |game| game.shots}
      team_shot_percentage_list[team_id] = (season_goals.to_f / season_shots).round(6)
      team_shot_percentage_list
    end
    team_id = team_shot_percentage_list.min_by { |team_id, shot_percentage| shot_percentage }.first
    @teams.find { |team| team.team_id == team_id }.team_name
  end

  def most_tackles(season_id)
    team_ids = team_ids_from_season(season_id)

    tackles_by_team_id = team_ids.reduce({}) do |tackles_by_team_id, team_id|
      team = @teams.find { |team| team.team_id == team_id }
      season_id_four = season_id[0..3]
      season_games = team.all_team_games.find_all { |game| game.game_id.start_with?(season_id_four) }
      season_tackles = season_games.sum { |game| game.tackles }
      tackles_by_team_id[team_id] = season_tackles
      tackles_by_team_id
    end
    team_id = tackles_by_team_id.max_by { |team_id, tackles| tackles }.first
    @teams.find { |team| team.team_id == team_id }.team_name
  end

  def fewest_tackles(season_id)
    team_ids = team_ids_from_season(season_id)

    tackles_by_team_id = team_ids.reduce({}) do |tackles_by_team_id, team_id|
      team = @teams.find { |team| team.team_id == team_id }
      season_id_four = season_id[0..3]
      season_games = team.all_team_games.find_all { |game| game.game_id.start_with?(season_id_four)}
      season_tackles = season_games.sum { |game| game.tackles }
      tackles_by_team_id[team_id] = season_tackles
      tackles_by_team_id
    end
    team_id = tackles_by_team_id.min_by { |team_id, tackles| tackles }.first
    @teams.find { |team| team.team_id == team_id }.team_name
  end
end
