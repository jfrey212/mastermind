# frozen_string_literal: true

# Game logic for mastermine game

require './mastermind_classes'
require './mastermind_modes'

# Introduction
system('clear')
puts "Welcome to Mastermind\npress any key to begin"
gets
puts

# Main game loop
# NOTE - player1 guesses the code, player2 chooses the code in first game
loop do
  print "Select an game option:\n"
  print "1. Player vs Player\n"
  print "2. vs Computer (Choose the Code)\n"
  print "3. vs Computer (Guess the Code)\n"
  print "4. Computer vs Computer\n"
  print "q to quit\n\n"
  print 'Selection: '
  puts
  answer = gets.chomp
  if answer =~ /[1234q]/
    case answer
    when '1'
      PlayerVsPlayer::pvp_game
    when '2'
      system('clear')
      player1 = ComputerPlayer.new
      player2 = HumanPlayer.new('player')
      puts '1 = Blue, 2 = Red, 3 = Yellow, 4 = Green, 5 = White, 6 = Black'
      print 'Player choose a secret 4-digit color code: '
      board = Board.new(gets.chomp)
      board.display
    when '3'
      system('clear')
      puts 'The Computer has chosen a code'
      player1 = HumanPlayer.new
      player2 = ComputerPlayer.new
      board = Board.new(player2.choose_code)
      board.display
    when '4'
      system('clear')
      player1 = ComputerPlayer.new
      player2 = ComputerPlayer.new
      board = Board.new(player2.choose_code)
      board.display
    when 'q'
      break
    end
  else
    puts 'Invalid input, please choose again'
    puts 'Press any key to continue'
    gets
    system('clear')
    next
  end
end
