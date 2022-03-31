# frozen_string_literal: true

# Classes for the mastermind game

# Methods for running a game
class Message
  def options
    print "Select an game option:\n"
    print "1. Player vs Player\n"
    print "2. vs Computer (Choose the Code)\n"
    print "3. vs Computer (Guess the Code)\n"
    print "4. Computer vs Computer\n"
    print "q to quit\n\n"
    print 'Selection: '
    puts
  end

  def color_key
    puts '1 = Blue, 2 = Red, 3 = Yellow, 4 = Green, 5 = White, 6 = Black'
  end

  def input_error
    puts 'Invalid input, please choose again'
    puts 'Press any key to continue'
    gets
  end
end

# Methods controlling the board
class Board
  def initialize(secret_code)
    @secret_code = secret_code
    @game_over = false
    @guess_count = 0
    @guesses = %w[0000 0000 0000 0000 0000 0000 0000 0000 0000 0000]
    @pegs = ['', '', '', '', '', '', '', '', '', '']
  end
  attr_accessor :guesses, :game_over, :guess_count
  attr_reader :secret_code

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

  def add_guess(new_guess)
    peg = compare_guess(new_guess)
    @guesses[@guess_count] = new_guess
    @pegs[@guess_count] = "#{peg[0]}x BP : #{peg[1]}x WP"
    @guess_count += 1
  end

  def compare_guess(guess)
    black_peg_matches = []
    num_black_pegs = 0
    num_white_pegs = 0

    compare_array = guess.digits.reverse.zip(@secret_code.digits.reverse)

    compare_array.each do |pair|
      next unless pair[0] == pair[1]

      num_black_pegs += 1

      black_peg_matches << pair
    end
    black_peg_matches.each do |pair|
      compare_array.delete_at(compare_array.find_index(pair))
    end

    wh_arr_guess = compare_array.map { |pair| pair[0] }
    wh_arr_code = compare_array.map { |pair| pair[1] }

    wh_arr_guess.each do |digit|
      if wh_arr_code.include?(digit)
        wh_arr_code.delete_at(wh_arr_code.find_index(digit))
        num_white_pegs += 1
      end
    end
    [num_black_pegs, num_white_pegs]
  end
end

# Due to needing the compare method for the minimax procedure, I ended up with
# two compare methods, one in the Board class and one in the minimax file.
# The one in the Board method is coupled to other class methods so I can't
# refactor to one compare method without substantial re-writes.
