# frozen_string_literal: true

# Game logic for mastermine game

require './mastermind_classes'

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
      code = gets.chomp
      if code =~ /\b[1-6]{4}\b/
        code = code.to_i
      else
        message.input_error
        next
      end
      board = Board.new(code)

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
        if board.guess_count == 13 && black_pegs < 4
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
      code = gets.chomp
      if code =~ /\b[1-6]{4}\b/
        code = code.to_i
      else
        message.input_error
        next
      end
      board = Board.new(code)
      board.display
    when '3'
      system('clear')
      code = [rand(1..6), rand(1..6), rand(1..6), rand(1..6)].join('').to_i
      puts 'The computer has chosen a 4-digit color code'
      puts 'Press enter to begin'
      gets
      board = Board.new(code)

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
        if board.guess_count == 13 && black_pegs < 4
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
      board = Board.new(player2.choose_code)
      board.display
    when 'q'
      break
    end
  else
    message.input_error
    system('clear')
    next
  end
end
