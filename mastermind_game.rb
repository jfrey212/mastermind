# frozen_string_literal: true

# Game logic for mastermine game

# My initial attempt to implement the Knuth mastermind algorithm did not work;
# it only solved every 10th secret code. Here I integrated an implemenation I
# found on GitHub by user zebogen <https://github.com/zebogen/mastermind-rb/blob/master/mastermind.rb>
# The logic is similar to my solution up until the membership_value assignment.

require './mastermind_classes'
require './minimax'
require 'set'

# Introduction
system('clear')
puts "Welcome to Mastermind\npress any key to begin"
gets
puts

# Main game loop
# NOTE - player1 guesses the code, player2 chooses the code in first game
loop do
  message = Message.new
  message.options
  answer = gets.chomp
  if answer =~ /[1234q]/
    case answer
    when '1'
      system('clear')
      message.color_key
      print 'Player2 choose a secret 4-digit color code: '
      secret_code = gets.chomp
      if secret_code =~ /\b[1-6]{4}\b/
        secret_code = secret_code.to_i
      else
        message.input_error
        next
      end
      board = Board.new(secret_code)

      loop do
        board.display
        puts
        print 'Your Guess: '
        guess = gets.chomp
        if guess =~ /\b[1-6]{4}\b/
          guess = guess.to_i
        else
          message.input_error
          next
        end
        board.add_guess(guess)
        black_pegs = board.compare_guess(guess)[0]
        if board.guess_count == 10 && black_pegs < 4
          board.game_over = true
          board.display
          puts "\nPlayer2 Wins - You didn't guess the code"
          puts 'Press enter to leave the game'
          gets
          break
        elsif black_pegs == 4
          board.game_over = true
          board.display
          puts "\nPlayer1 Wins - You guessed the code"
          puts 'Press enter to leave the game'
          gets
          break
        end
      end
    when '2'
      system('clear')
      message.color_key
      print 'Player choose a secret 4-digit color code: '
      secret_code = gets.chomp
      guess = 1122
      if secret_code =~ /\b[1-6]{4}\b/
        secret_code = secret_code.to_i
      else
        message.input_error
        next
      end

      unused_codes = create_codes
      potential_codes = Set.new(unused_codes)
      board = Board.new(secret_code)

      loop do
        board.add_guess(guess)
        board.display
        score = compare(guess, secret_code)

        if score == [4, 0]
          board.game_over = true
          board.display
          puts "\nThe computer found the secret code in #{board.guess_count} turns"
          break
        elsif board.guess_count == 10
          board.game_over = true
          board.display
          puts "\nThe computer did not find the secret code"
          break
        end

        unused_codes.reject! { |code| code == guess }
        potential_codes.select! { |code| compare(code, guess) == score }

        possible_guesses = unused_codes.map do |possible_guess|
          hit_counts = potential_codes.each_with_object(Hash.new(0)) do |potential_code, counts|
            counts[compare(potential_code, possible_guess)] += 1
          end

          highest_hit_count = hit_counts.values.max || 0

          membership_value = potential_codes.include?(possible_guess) ? 0 : 1

          [highest_hit_count, membership_value, possible_guess]
        end

        guess = possible_guesses.min.last
        sleep(1)
      end
    when '3'
      system('clear')
      secret_code = [rand(1..6), rand(1..6), rand(1..6), rand(1..6)].join('').to_i
      puts 'The computer has chosen a 4-digit color code'
      puts 'Press enter to begin'
      gets
      board = Board.new(secret_code)

      loop do
        board.display
        puts
        print 'Your Guess: '
        guess = gets.chomp
        if guess =~ /\b[1-6]{4}\b/
          guess = guess.to_i
        else
          message.input_error
          next
        end
        board.add_guess(guess)
        black_pegs = board.compare_guess(guess)[0]
        if board.guess_count == 10 && black_pegs < 4
          board.game_over = true
          board.display
          puts "\nComputer Wins - You didn't guess the code"
          puts 'Press enter to leave the game'
          gets
          break
        elsif black_pegs == 4
          board.game_over = true
          board.display
          puts "\nPlayer1 Wins - You guessed the code"
          puts 'Press enter to leave the game'
          gets
          break
        end
      end
    when '4'
      system('clear')
      puts 'Computer has selected a code'
      sleep(2)

      # Brute force methods determined only an initial guess of the form aabb
      # will find the code in 5 turns or less
      guess = 1122
      secret_code = [rand(1..6), rand(1..6), rand(1..6), rand(1..6)].join('').to_i
      board = Board.new(secret_code)

      # unused_codes is the full list of 1296 possible codes. potential_codes
      # is the list S of codes that will be eliminated after each turn
      unused_codes = create_codes
      potential_codes = Set.new(unused_codes)

      loop do
        board.add_guess(guess)
        board.display
        score = compare(guess, secret_code)

        if score == [4, 0]
          board.game_over = true
          board.display
          puts "\nThe computer found the secret code in #{board.guess_count} turns"
          break
        elsif board.guess_count == 10
          board.game_over = true
          board.display
          puts "\nThe computer did not find the secret code"
          break
        end

        # Remove the guess from the total code list and remove all scores from
        # S that have different peg scores from the guess. I'm using S to refer to
        # potential_codes because the algorithm description uses S for this list
        unused_codes.reject! { |code| code == guess }
        potential_codes.select! { |code| compare(code, guess) == score }

        # This is the minimax step. Each possible guess in the list of all
        # guesses (unused_codes) is compared with each code in the potential_code list (S).
        # These comparisons populate a hash called hit_counts with the number of
        # each possible peg score. The highest score in this list represents the
        # worst case scenario for that guess - the most unknowns. The membership_value
        # represents whether a given guess is present in the possible_guess list
        # (S). The min test at the end finds the possible guess with the lowest
        # max hit count. The membership_value selects a value in the possible
        # guess list S if available. If two or more value have the same highest
        # hit count and membership_value, the lowest numerical value is used to select
        # the next guess. This comparison is the piece I was missing from my
        # implementation of the algorithm.
        possible_guesses = unused_codes.map do |possible_guess|
          hit_counts = potential_codes.each_with_object(Hash.new(0)) do |potential_code, counts|
            counts[compare(potential_code, possible_guess)] += 1
          end

          highest_hit_count = hit_counts.values.max || 0

          membership_value = potential_codes.include?(possible_guess) ? 0 : 1

          [highest_hit_count, membership_value, possible_guess]
        end

        guess = possible_guesses.min.last
        sleep(1)
      end
    when 'q'
      break
    end
  else
    message.input_error
    system('clear')
    next
  end
end
