defmodule Chex.Piece.PawnTest do
  use ExUnit.Case
  doctest Chex.Piece.Pawn

  alias Chex.Piece

  describe "Piece.possible_moves/2 with pawn" do
    test "white pawn first move" do
      {:ok, game} = Chex.Game.new()
      moves = Piece.possible_moves(game, {:e, 2})
      expected_moves = [{:e, 3}, {:e, 4}]

      assert Enum.sort(moves) == Enum.sort(expected_moves)
    end

    test "black pawn first move" do
      {:ok, game} = Chex.Game.new()
      moves = Piece.possible_moves(game, {:d, 7})
      expected_moves = [{:d, 6}, {:d, 5}]

      assert Enum.sort(moves) == Enum.sort(expected_moves)
    end

    test "white pawn normal move" do
      {:ok, game} = Chex.Game.new("4k3/8/8/8/3P4/8/8/4K3 w - - 0 1")
      moves = Piece.possible_moves(game, {:d, 4})
      expected_moves = [{:d, 5}]

      assert moves == expected_moves
    end

    test "black pawn normal move" do
      {:ok, game} = Chex.Game.new("4k3/8/8/3p4/8/8/8/4K3 w - - 0 1")
      moves = Piece.possible_moves(game, {:d, 5})
      expected_moves = [{:d, 4}]

      assert moves == expected_moves
    end

    test "white pawn attacking squares move" do
      {:ok, game} = Chex.Game.new("4k3/8/8/2p1p3/3P4/8/8/4K3 w - - 0 1")
      moves = Piece.possible_moves(game, {:d, 4})
      expected_moves = [{:c, 5}, {:d, 5}, {:e, 5}]

      assert Enum.sort(moves) == Enum.sort(expected_moves)
    end

    test "pawn can not move to an occupied square" do
      {:ok, game} =
        Chex.Game.new("rnbqk2r/pppp1ppp/5n2/1B2p3/1b2P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 0 1")

      assert Piece.possible_moves(game, {:e, 4}) == []
      assert Piece.possible_moves(game, {:e, 5}) == []
      assert Piece.possible_moves(game, {:f, 2}) == []
      assert Piece.possible_moves(game, {:f, 7}) == []
      refute {:b, 4} in Piece.possible_moves(game, {:b, 2})
      refute {:b, 5} in Piece.possible_moves(game, {:b, 7})
    end
  end
end
