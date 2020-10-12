defmodule Chex.Piece.PawnTest do
  use ExUnit.Case
  doctest Chex.Piece.Pawn

  test "white pawn first move" do
    {:ok, game} = Chex.Game.new()
    moves = Chex.Piece.Pawn.possible_moves(:white, {:e, 2}, game)
    expected_moves = [{:e, 3}, {:e, 4}]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "black pawn first move" do
    {:ok, game} = Chex.Game.new()
    moves = Chex.Piece.Pawn.possible_moves(:black, {:d, 7}, game)
    expected_moves = [{:d, 6}, {:d, 5}]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "white pawn normal move" do
    {:ok, game} = Chex.Game.new("4k3/8/8/8/3P4/8/8/4K3 w - - 0 1")
    moves = Chex.Piece.Pawn.possible_moves(:white, {:d, 4}, game)
    expected_moves = [{:d, 5}]

    assert moves == expected_moves
  end

  test "black pawn normal move" do
    {:ok, game} = Chex.Game.new("4k3/8/8/3p4/8/8/8/4K3 w - - 0 1")
    moves = Chex.Piece.Pawn.possible_moves(:black, {:d, 5}, game)
    expected_moves = [{:d, 4}]

    assert moves == expected_moves
  end

  test "white pawn attacking squares move" do
    {:ok, game} = Chex.Game.new("4k3/8/8/2p1p3/3P4/8/8/4K3 w - - 0 1")
    moves = Chex.Piece.Pawn.possible_moves(:white, {:d, 4}, game)
    expected_moves = [{:c, 5}, {:d, 5}, {:e, 5}]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "pawn can not move to an occupied square" do
    {:ok, game} = Chex.Game.new("r1bqkb1r/pppppppp/2n5/8/4n3/N6N/PPPPPPPP/R1BQKB1R b KQkq - 0 1")
    moves = Chex.Piece.possible_moves(game, {:e, 2})

    refute {:e, 4} in moves
  end
end
