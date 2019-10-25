defmodule Chex.Piece.KingTest do
  use ExUnit.Case
  import AssertValue
  doctest Chex.Piece.King

  test "all moves valid" do
    game = Chex.Game.new("4k3/8/8/8/3K4/8/8/8 w - - 0 1")

    moves = Chex.Piece.King.possible_moves(:white, {:d, 4}, game)

    expected_moves = [
      {:c, 5},
      {:d, 5},
      {:e, 5},
      {:c, 4},
      {:e, 4},
      {:c, 3},
      {:d, 3},
      {:e, 3}
    ]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "king in corner" do
    game = Chex.Game.new("4k3/8/8/8/8/8/8/K7 w - - 0 1")

    moves = Chex.Piece.King.possible_moves(:white, {:a, 1}, game)

    expected_moves = [
      {:a, 2},
      {:b, 2},
      {:b, 1}
    ]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end
end
