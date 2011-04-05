class NeedTwoPlayers < StandardError; end
class RockPaperScissors
  attr_reader :players
  attr_reader :winners

  def initialize
    @players = []
    @winners = []
  end

  def join(player, move)
    @players << {player => move}
  end

  def one_two_three_shoot!
    validate_game
    calculate_winners
  end

  def validate_game
    # implement me
  end

  def calculate_winners
    # Implement me
    @winners = []
  end

end