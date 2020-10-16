defmodule Chex.Piece.QueenTest do
  use ExUnit.Case, async: true
  doctest Chex.Piece.Queen

  alias Chex.Piece.Queen

  @empty_board "8/8/8/8/4Q3/8/8/8 w - - 0 1"

  describe "Queen.possible_moves/3" do
    test "white starting position moves" do
      {:ok, game} = Chex.Game.new()
      assert Queen.possible_moves(:white, {:d, 1}, game) == []
    end

    test "black starting position moves" do
      {:ok, game} = Chex.Game.new()
      assert Queen.possible_moves(:black, {:d, 8}, game) == []
    end

    test "only piece in middle of board" do
      {:ok, game} = Chex.Game.new(@empty_board)
      moves = Queen.possible_moves(:white, {:e, 4}, game)

      expected_moves = [
        {:a, 4},
        {:a, 8},
        {:b, 1},
        {:b, 4},
        {:b, 7},
        {:c, 2},
        {:c, 4},
        {:c, 6},
        {:d, 3},
        {:d, 4},
        {:d, 5},
        {:e, 1},
        {:e, 2},
        {:e, 3},
        {:e, 5},
        {:e, 6},
        {:e, 7},
        {:e, 8},
        {:f, 3},
        {:f, 4},
        {:f, 5},
        {:g, 2},
        {:g, 4},
        {:g, 6},
        {:h, 1},
        {:h, 4},
        {:h, 7}
      ]

      assert Enum.sort(moves) == expected_moves
    end

    test "surrounded by enemy pawns" do
      {:ok, game} = Chex.Game.new("8/8/8/3ppp2/3pQp2/3ppp2/8/8 w - - 0 1")
      moves = Queen.possible_moves(:white, {:e, 4}, game)

      expected_moves = [d: 3, d: 4, d: 5, e: 3, e: 5, f: 3, f: 4, f: 5]

      assert Enum.sort(moves) == expected_moves
    end

    test "surrounded by friendly pawns" do
      {:ok, game} = Chex.Game.new("8/8/8/3ppp2/3pqp2/3ppp2/8/8 w - - 0 1")
      moves = Queen.possible_moves(:black, {:e, 4}, game)

      expected_moves = []

      assert Enum.sort(moves) == expected_moves
    end
  end
end
