defmodule Chex.Piece.KnightTest do
  use ExUnit.Case, async: true
  doctest Chex.Piece.Knight

  alias Chex.Piece

  @empty_board "8/8/8/4N3/8/8/8/8 w - - 0 1"

  describe "Piece.possible_moves/2 with knight" do
    test "starting position moves" do
      {:ok, game} = Chex.Game.new()
      moves = Piece.possible_moves(game, {:b, 1})
      assert Enum.sort(moves) == [a: 3, c: 3]
    end

    test "only piece in middle of board" do
      {:ok, game} = Chex.Game.new(@empty_board)
      moves = Piece.possible_moves(game, {:e, 5})

      expected_moves = [g: 6, g: 4, c: 6, c: 4, f: 7, f: 3, d: 7, d: 3]

      assert Enum.sort(moves) == Enum.sort(expected_moves)
    end

    test "surrounded by enemy pawns" do
      {:ok, game} = Chex.Game.new("8/8/3ppp2/3pNp2/3ppp2/8/8/8 w - - 0 1")
      moves = Piece.possible_moves(game, {:e, 5})

      expected_moves = [g: 6, g: 4, c: 6, c: 4, f: 7, f: 3, d: 7, d: 3]

      assert Enum.sort(moves) == Enum.sort(expected_moves)
    end
  end
end
