class Team
  attr_reader :team_id,
              :franchise_id,
              :team_name,
              :abbreviation,
              :link,
              :all_team_games,
              :all_opponent_games

  def initialize(team_info, all_team_games, all_opponent_games)
    @team_id = team_info[:team_id]
    @franchise_id = team_info[:franchiseid]
    @team_name = team_info[:teamname]
    @abbreviation = team_info[:abbreviation]
    @link = team_info[:link]
    @all_team_games = all_team_games
    @all_opponent_games = all_opponent_games
  end

  def win_percentage
    win_count = @all_team_games.count do |game|
      game.result == "WIN"
    end
    (win_count / @all_team_games.length.to_f).round(2)
  end

  def average_goals_scored_per_game
    goal_count = @all_team_games.sum do |game|
      game.goals
    end
    (goal_count / @all_team_games.length.to_f).round(2)
  end

  def average_goals_allowed_per_game
    goal_count = @all_opponent_games.sum do |game|
      game.goals
    end
    (goal_count / @all_opponent_games.length.to_f).round(2)
  end

  def home_win_percentage
    total_home_games = 0
    win_count = @all_team_games.count do |game|
      if game.hoa == "home"
        total_home_games += 1
      end
      game.result == "WIN" && game.hoa == "home"
    end
    (win_count.to_f / total_home_games * 100).round(2)
  end

  def away_win_percentage
    total_away_games = 0
    win_count = @all_team_games.count do |game|
      if game.hoa == "away"
        total_away_games += 1
      end
      game.result == "WIN" && game.hoa == "away"
    end
    (win_count.to_f / total_away_games * 100).round(2)
  end

  def away_games_by_team
    away_games = @all_team_games.find_all { |game| game.hoa == "away"}
  end

  def home_games_by_team
    home_games = @all_team_games.find_all { |game| game.hoa == "home" }
  end

  def away_game_goals
    away_goals_sum = away_games_by_team.sum { |game| game.goals }
  end

  def home_game_goals
    home_goals_sum = home_games_by_team.sum { |game| game.goals }
  end

  def most_goals_scored
    @all_team_games.max_by {|game| game.goals}.goals
  end

  def fewest_goals_scored
    @all_team_games.min_by {|game| game.goals}.goals
  end

  def biggest_blowout
    @all_team_games.map.with_index do |game, index|
      game.goals - @all_opponent_games[index].goals
    end.max
  end

  def worst_loss
    @all_team_games.map.with_index do |game, index|
      game.goals - @all_opponent_games[index].goals
    end.min.abs
  end

  def head_to_head(team_names_list)
    list = @all_opponent_games.reduce({}) do |new_list, game|
      opponent_name = team_names_list[game.team_id]
      if !new_list.keys.include?(opponent_name)
        new_list[opponent_name] = []
      end
      new_list[opponent_name] << game
      new_list
    end
    list.transform_values do |games_array|
      win_count = games_array.count {|game| game.result == "LOSS"}
      (win_count.to_f / games_array.length).round(2)
    end
  end
end
