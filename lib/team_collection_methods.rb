module TeamCollectionMethods
  def best_offense
    @total_teams.max_by do |team|
      team.average_goals_scored_per_game
    end.team_name
  end

  def worst_offense
    @total_teams.min_by do |team|
      team.average_goals_scored_per_game
    end.team_name
  end

  def best_defense
    @total_teams.min_by do |team|
      team.average_goals_allowed_per_game
    end.team_name
  end

  def worst_defense
    @total_teams.max_by do |team|
      team.average_goals_allowed_per_game
    end.team_name
  end

  def winningest_team
    @total_teams.max_by do |team|
      team.win_percentage
    end.team_name
  end

  def best_fans
    @total_teams.max_by do |team|
      team.home_win_percentage - team.away_win_percentage
    end.team_name
  end

  def worst_fans
    worst_fans_list = @total_teams.find_all do |team|
      team.away_win_percentage > team.home_win_percentage
    end
    worst_fans_list.map do |team|
      team.team_name
    end
  end

  def highest_scoring_visitor
    highest_away_team = @total_teams.max_by do |team|
      team.away_game_goals / team.away_games_by_team.count.to_f
    end
    highest_away_team.team_name
  end

  def highest_scoring_home_team
    highest_home_team = @total_teams.max_by do |team|
      team.home_game_goals / team.home_games_by_team.count.to_f
    end
    highest_home_team.team_name
  end

  def lowest_scoring_visitor
    lowest_scoring_away_team = @total_teams.min_by do |team|
      team.away_game_goals / team.away_games_by_team.count.to_f
    end
    lowest_scoring_away_team.team_name
  end

  def lowest_scoring_home_team
    lowest_scoring_home = @total_teams.min_by do |team|
      team.home_game_goals / team.home_games_by_team.count.to_f
    end
    lowest_scoring_home.team_name
  end

  def team_info(team_id)
    team_information = {}
    @total_teams.map do |team|
      if team_id == team.team_id
        team_information["team_id"] = team.team_id
        team_information["franchise_id"] = team.franchise_id
        team_information["team_name"] = team.team_name
        team_information["abbreviation"] = team.abbreviation
        team_information["link"] = team.link
      end
    end
    team_information
  end

  def all_team_games(team_id)
    all_games = @total_games.count { |game| game.team_id == team_id }
  end

  def all_won_games(team_id)
    wins = @total_games.count { |game| game.result == "WIN" && game.team_id == team_id }
  end

  def average_win_percentage(team_id)
    avg_win_percentage = (all_won_games(team_id).to_f / all_team_games(team_id)).round(2)
  end

  def most_goals_scored(team_id)
    team = @total_teams.find {|team| team.team_id == team_id }
    team.most_goals_scored
  end

  def fewest_goals_scored(team_id)
    team = @total_teams.find {|team| team.team_id == team_id }
    team.fewest_goals_scored
  end

  def favorite_opponent(team_id)
    team = @total_teams.find { |team| team.team_id == team_id }
    all_opponent_games = team.all_opponent_games
    team_ids_played_against = all_opponent_games.map { |game| game.team_id }.uniq
    x = team_ids_played_against.reduce({}) do |opponent_id_percentage_won, opponent_id|
      opponent_games = all_opponent_games.find_all { |game| game.team_id == opponent_id}
      number_of_games_won_by_opponent = opponent_games.count{ |game| game.result == "WIN"}
      opponent_id_percentage_won[opponent_id] = number_of_games_won_by_opponent / opponent_games.length.to_f
      opponent_id_percentage_won
    end
    team_id = x.min_by { |k,v| v}.first
    @total_teams.find { |team| team.team_id == team_id }.team_name
  end

  def rival(team_id)
    team = @total_teams.find { |team| team.team_id == team_id }
    all_opponent_games = team.all_opponent_games
    team_ids_played_against = all_opponent_games.map { |game| game.team_id }.uniq

    x = team_ids_played_against.reduce({}) do |opponent_id_percentage_won, opponent_id|
      opponent_games = all_opponent_games.find_all { |game| game.team_id == opponent_id}
      number_of_games_won_by_opponent = opponent_games.count{ |game| game.result == "WIN"}
      opponent_id_percentage_won[opponent_id] = number_of_games_won_by_opponent / opponent_games.length.to_f
      opponent_id_percentage_won
    end

    team_id = x.max_by { |k,v| v}.first
    @total_teams.find { |team| team.team_id == team_id }.team_name
  end

  def biggest_team_blowout(team_id)
    select_team = @total_teams.find {|team| team.team_id == team_id}
    select_team.biggest_blowout
  end

  def worst_loss(team_id)
    select_team = @total_teams.find {|team| team.team_id == team_id}
    select_team.worst_loss
  end

  def head_to_head(team_id)
    team_names_list = @total_teams.reduce({}) do |new_list, team|
      new_list[team.team_id] = team.team_name
      new_list
    end
    select_team = @total_teams.find {|team| team.team_id == team_id}
    select_team.head_to_head(team_names_list)
  end
end
