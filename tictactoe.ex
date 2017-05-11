defmodule M do

  use Bitwise, only_operators: true
  import Kernel

  @winning_bitboards [
    [1, 1, 1,
     0, 0, 0,
     0, 0, 0],

    [0, 0, 0,
     1, 1, 1,
     0, 0, 0],

    [0, 0, 0,
     0, 0, 0,
     1, 1, 1],

    [1, 0, 0,
     1, 0, 0,
     1, 0, 0],

    [0, 1, 0,
     0, 1, 0,
     0, 1, 0],

    [0, 0, 1,
     0, 0, 1,
     0, 0, 1],

    [1, 0, 0,
     0, 1, 0,
     0, 0, 1],

    [0, 0, 1,
     0, 1, 0,
     1, 0, 0]
   ]

  def bitwise_and(a, b) do
    Enum.map(Enum.zip(a, b), fn({bit_a, bit_b}) -> bit_a &&& bit_b end)
  end

  def equals(a, b) do
    diff = a -- b
    if length(diff) == 0 do
      true
    else
      false
    end
  end

  def bitboard_statematch(bitboard, [first_state | rest_states]) do
    if equals(bitwise_and(bitboard, first_state), first_state) do
      true
    else
      if length(rest_states) > 0 do
        bitboard_statematch(bitboard, rest_states)
      else
        false
      end
    end
  end

  def is_bit_victory(bitboard) do
    bitboard_statematch(bitboard, @winning_bitboards)
  end

  def to_bit(value) do
    if value, do: 1, else: 0
  end

  def compile_bitboard(board, sign) do
      if is_bitstring(board) do
        board = String.split(String.replace(board , ~r/\s/, ""), "")
      else
        board = List.flatten(board)
      end
      Enum.map(board, fn(value) -> to_bit(value === sign) end)
  end

  def is_victory(board, sign) do
    is_bit_victory(compile_bitboard(board, sign))
  end

  def main do
    IO.puts "expecting true:"
    IO.puts is_victory(" ono\n xon\n xno", "o")
    IO.puts "expecting true:"
    IO.puts is_victory([
      ["x", "o",  "_"],
      ["x",  "_", "o"],
      ["x",  "o", "_"]
    ], "x")

    IO.puts "\nexpecting false:"
    IO.puts is_victory(" xno\n xon\n xno", "o")
    IO.puts "expecting false:"
    IO.puts is_victory(" _no\n xon\n xno", "x")
  end

end

M.main
