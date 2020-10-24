defmodule Chex.Piece.PawnTest do
  use ExUnit.Case
  doctest Chex.Piece.Pawn

  alias Chex.Piece.Pawn

  test "white pawn first move" do
    {:ok, game} = Chex.Game.new()
    moves = Pawn.possible_moves(:white, {:e, 2}, game)
    expected_moves = [{:e, 3}, {:e, 4}]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "black pawn first move" do
    {:ok, game} = Chex.Game.new()
    moves = Pawn.possible_moves(:black, {:d, 7}, game)
    expected_moves = [{:d, 6}, {:d, 5}]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "white pawn normal move" do
    {:ok, game} = Chex.Game.new("4k3/8/8/8/3P4/8/8/4K3 w - - 0 1")
    moves = Pawn.possible_moves(:white, {:d, 4}, game)
    expected_moves = [{:d, 5}]

    assert moves == expected_moves
  end

  test "black pawn normal move" do
    {:ok, game} = Chex.Game.new("4k3/8/8/3p4/8/8/8/4K3 w - - 0 1")
    moves = Pawn.possible_moves(:black, {:d, 5}, game)
    expected_moves = [{:d, 4}]

    assert moves == expected_moves
  end

  test "white pawn attacking squares move" do
    {:ok, game} = Chex.Game.new("4k3/8/8/2p1p3/3P4/8/8/4K3 w - - 0 1")
    moves = Pawn.possible_moves(:white, {:d, 4}, game)
    expected_moves = [{:c, 5}, {:d, 5}, {:e, 5}]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "pawn can not move to an occupied square" do
    {:ok, game} =
      Chex.Game.new("rnbqk2r/pppp1ppp/5n2/1B2p3/1b2P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 0 1")

    assert Chex.Piece.possible_moves(game, {:e, 4}) == []
    assert Chex.Piece.possible_moves(game, {:e, 5}) == []
    assert Chex.Piece.possible_moves(game, {:f, 2}) == []
    assert Chex.Piece.possible_moves(game, {:f, 7}) == []
    refute {:b, 4} in Chex.Piece.possible_moves(game, {:b, 2})
    refute {:b, 5} in Chex.Piece.possible_moves(game, {:b, 7})
  end
end
