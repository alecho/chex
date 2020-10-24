defmodule Chex.Piece.BishopTest do
  use ExUnit.Case, async: true
  doctest Chex.Piece.Bishop

  alias Chex.Piece

  @empty_board "8/8/8/8/4B3/8/8/8 w - - 0 1"

  describe "Piece.possible_moves/2 with bishop" do
    test "white starting position moves" do
      {:ok, game} = Chex.Game.new()
      assert Piece.possible_moves(game, {:c, 1}) == []
    end

    test "black starting position moves" do
      {:ok, game} = Chex.Game.new()
      assert Piece.possible_moves(game, {:c, 8}) == []
    end

    test "only piece in middle of board" do
      {:ok, game} = Chex.Game.new(@empty_board)
      moves = Piece.possible_moves(game, {:e, 4})

      expected_moves = [
        a: 8,
        b: 1,
        b: 7,
        c: 2,
        c: 6,
        d: 3,
        d: 5,
        f: 3,
        f: 5,
        g: 2,
        g: 6,
        h: 1,
        h: 7
      ]

      assert Enum.sort(moves) == expected_moves
    end

    test "surrounded by enemy pawns" do
      {:ok, game} = Chex.Game.new("8/8/8/3ppp2/3pBp2/3ppp2/8/8 w - - 0 1")
      moves = Piece.possible_moves(game, {:e, 4})

      assert Enum.sort(moves) == [d: 3, d: 5, f: 3, f: 5]
    end
  end
end
