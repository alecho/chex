defmodule Chex.Piece.RookTest do
  use ExUnit.Case, async: true
  doctest Chex.Piece.Rook

  @empty_board "8/8/8/8/4R3/8/8/8 w - - 0 1"

  describe "Rook.possible_moves/3" do
    test "starting position moves" do
      {:ok, game} = Chex.Game.new()
      assert Chex.Piece.Rook.possible_moves(:white, {:a, 1}, game) == []
    end

    test "only piece in middle of board" do
      {:ok, game} = Chex.Game.new(@empty_board)
      moves = Chex.Piece.Rook.possible_moves(:white, {:e, 4}, game)

      expected_moves = [
        {:a, 4},
        {:b, 4},
        {:c, 4},
        {:d, 4},
        {:e, 1},
        {:e, 2},
        {:e, 3},
        {:e, 5},
        {:e, 6},
        {:e, 7},
        {:e, 8},
        {:f, 4},
        {:g, 4},
        {:h, 4}
      ]

      assert Enum.sort(moves) == expected_moves
    end

    test "surrounded by enemy pawns" do
      {:ok, game} = Chex.Game.new("8/8/8/3ppp2/3pRp2/3ppp2/8/8 w - - 0 1")
      moves = Chex.Piece.Rook.possible_moves(:white, {:e, 4}, game)

      expected_moves = [
        {:d, 4},
        {:e, 3},
        {:e, 5},
        {:f, 4}
      ]

      assert Enum.sort(moves) == expected_moves
    end
  end
end
