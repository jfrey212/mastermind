# frozen_string_literal: true

# Game mode modules for mastermind_classes

require './mastermind_classes'

# Module for player vs player game
module PlayerVsPlayer
  def pvp_game
    system('clear')
    player1 = HumanPlayer.new
    player2 = HumanPlayer.new
    puts '1 = Blue, 2 = Red, 3 = Yellow, 4 = Green, 5 = White, 6 = Black'
    print 'Player choose a secret 4-digit color code: '
    board = Board.new(gets.chomp)
  end
end

# Module for player vs computer game
module PlayerVsComputer; end

# Module for computer vs player game
module ComputerVsComputer; end

# Module for computer vs computer game
module ComputerVsComputer; end
