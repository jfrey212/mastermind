# frozen_string_literal: true

# Classes for the mastermind game

# Methods for running a game
class Game
  def initialize; end
end

# Methods controlling the board
class Board
  def initialize(secret_code)
    @secret_code = secret_code
    @game_over = false
    @guesses = %w[0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000]
    @pegs = ['', '', '', '', '', '', '', '', '', '', '', '']
  end
  attr_accessor :guesses, :pegs, :game_over

  def display
    system('clear')
    puts "\tMASTERMIND"
    puts
    @guesses.each_with_index do |guess, i|
      puts "\t#{i + 1}\t#{guess}\t#{@pegs[i]}"
      puts
    end
    if @game_over == true
      puts "\tCode:\t#{@secret_code}"
    else
      puts "\tCode:\tXXXX"
    end
    puts
    puts '1 = Blue, 2 = Red, 3 = Yellow, 4 = Green, 5 = White, 6 = Black'
    puts 'BP = Black Peg, WP = White Peg'
  end

  def add_guess(new_guess, guess_number = 1)
    peg = compare_guess(new_guess)
    @guesses[guess_number - 1] = new_guess
    @pegs[guess_number - 1] = "#{peg[0]}x BP : #{peg[1]}x WP"
  end

  def compare_guess(guess)
    black_peg_matches = []

    # Find the black pegs first - number by number comparison, store matching
    # pairs in a new array - black_peg_matches. Number of black pegs stored in
    # num_black_pegs. I refactored the compare_array generation to use zip instead of
    # each_with_index after some research online
    compare_array = guess.digits.reverse.zip(@secret_code.digits.reverse)

    compare_array.each do |pair|
      next unless pair[0] == pair[1]

      black_peg_matches << pair
    end
    num_black_pegs = black_peg_matches.length

    # Find the white pegs. First remove the black peg matches. Only need a count
    # here.
    num_white_pegs = 0
    white_peg_array = (compare_array | black_peg_matches) - (compare_array & black_peg_matches)
    wh_arr_guess = white_peg_array.map { |pair| pair[0] }
    wh_arr_code = white_peg_array.map { |pair| pair[1] }
    wh_arr_guess.each do |digit|
      if wh_arr_code.include?(digit)
        wh_arr_code.delete_at(wh_arr_code.find_index(digit))
        num_white_pegs += 1
      end
    end
    [num_black_pegs, num_white_pegs]
  end
end

# Methods for the human player
class HumanPlayer
  def initialize(name = 'Player')
    @name = name
  end
end

# Methods for the computer player
class ComputerPlayer
  def initialize(name = 'Computer')
    @name = name
  end
end
