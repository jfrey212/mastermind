# frozen_string_literal: true

# Implementation of Knuth mastermind algorithm

# Create an array of 1296 codes 1111..6666

require 'pry-byebug'

  def create_codes
    max = 6666
    combo = 1111
    array = []

    while combo <= max
      array << combo.to_s
      combo += 1
    end
    array
    array.select! { |num| num =~ /[1-6][1-6][1-6][1-6]/ }
    array.map(&:to_i)
  end

  # Compare a guess to a code and return a two item array with black peg count
  # and white peg count
  def compare(guess, code)
    black_peg_matches = []

    compare_array = guess.digits.reverse.zip(code.digits.reverse)

    compare_array.each do |pair|
      next unless pair[0] == pair[1]

      black_peg_matches << pair
    end
    num_black_pegs = black_peg_matches.length

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

  # Original minimax methods. Only worked for 1 out of 10 of the 1296 color code

  # # Uses a guess to generate the next s array for the minimax
  # def next_s(guess, code, prev_s)
  #   pegs = compare(guess, code)
  #   prev_s.select do |num|
  #     compare(num, guess) == pegs
  #   end
  # end
  #
  # # Return a hash of possible scores
  # def table
  #   { [0, 0] => 0, [0, 1] => 0, [0, 2] => 0, [0, 3] => 0, [0, 4] => 0,
  #     [1, 0] => 0, [1, 1] => 0, [1, 2] => 0, [1, 3] => 0,
  #     [2, 0] => 0, [2, 1] => 0, [2, 2] => 0,
  #     [3, 0] => 0,
  #     [4, 0] => 0 }
  # end
  #
  # # perform minimax algorithm on list of possible answers s from playing
  # # 1122, or any number of the form aabb. Returns a new guess based on the
  # # lowest scoring number
  # def minimax(current_s)
  #   all_guesses = create_array
  #   all_scores = {}
  #   all_guesses.each do |guess|
  #     t = table
  #     current_s.each do |s_guess|
  #       pegs = compare(guess, s_guess)
  #       t[pegs] += 1
  #     end
  #     score = t.values.max
  #     all_scores[guess] = score
  #   end
  #   sorted_scores = all_scores.sort_by { |_, value| value }
  #   sorted_scores[0][0]
  # end
