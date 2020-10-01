defmodule Chex.Piece.KnightTest do
  use ExUnit.Case, async: true
  doctest Chex.Piece.Knight

  @empty_board "8/8/8/4N3/8/8/8/8 w - - 0 1"

  describe "Knight.possible_moves/3" do
    test "starting position moves" do
      {:ok, game} = Chex.Game.new()
      moves = Chex.Piece.Knight.possible_moves(:white, {:b, 1}, game)
      assert Enum.sort(moves) == [a: 3, c: 3]
    end

    test "only piece in middle of board" do
      {:ok, game} = Chex.Game.new(@empty_board)
      moves = Chex.Piece.Knight.possible_moves(:white, {:e, 5}, game)

      expected_moves = [g: 6, g: 4, c: 6, c: 4, f: 7, f: 3, d: 7, d: 3]

      assert Enum.sort(moves) == Enum.sort(expected_moves)
    end

    test "surrounded by enemy pawns" do
      {:ok, game} = Chex.Game.new("8/8/3ppp2/3pNp2/3ppp2/8/8/8 w - - 0 1")
      moves = Chex.Piece.Knight.possible_moves(:white, {:e, 5}, game)

      expected_moves = [g: 6, g: 4, c: 6, c: 4, f: 7, f: 3, d: 7, d: 3]

      assert Enum.sort(moves) == Enum.sort(expected_moves)
    end
  end
end
