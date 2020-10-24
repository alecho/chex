defmodule Chex.Piece.RookTest do
  use ExUnit.Case, async: true
  doctest Chex.Piece.Rook

  alias Chex.Piece

  @empty_board "8/8/8/8/4R3/8/8/8 w - - 0 1"

  describe "Piece.possible_moves/2 with rook" do
    test "starting position moves" do
      {:ok, game} = Chex.Game.new()
      assert Piece.possible_moves(game, {:a, 1}) == []
    end

    test "only piece in middle of board" do
      {:ok, game} = Chex.Game.new(@empty_board)
      moves = Piece.possible_moves(game, {:e, 4})

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
      moves = Piece.possible_moves(game, {:e, 4})

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
