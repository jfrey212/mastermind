# frozen_string_literal: true

#Implementation of Knuth mastermind algorithm

# Create an array of 1296 codes 1111..6666
def create_array
    max = 6666
    combo = 1111
    array = []

    while combo <= max
      array << digit.to_s
      combo += 1
    end
    array = array.select { |num| num =~ /[1-6][1-6][1-6][1-6]/ }
    s = array.map(&:to_i)
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

  # Return a hash of possible scores
  def table
    { [0, 0] => 0, [0, 1] => 0, [0, 2] => 0, [0, 3] => 0, [0, 4] => 0,
      [1, 0] => 0, [1, 1] => 1, [1, 2] => 0, [1, 3] => 0,
      [2, 0] => 0, [2, 1] => 0, [2, 2] => 0,
      [3, 0] => 0,
      [4, 0] => 0 }
  end
