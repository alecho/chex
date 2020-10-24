defmodule Chex.PieceTest do
  use ExUnit.Case, asyc: true
  import AssertValue
  doctest Chex.Piece

  alias Chex.{Game, Piece}

  test "correctly parses pieces" do
    results =
      "kqbnrpKQBNRP"
      |> String.codepoints()
      |> Enum.map(&Chex.Piece.from_string(&1))

    assert_value(
      results == [
        king: :black,
        queen: :black,
        bishop: :black,
        knight: :black,
        rook: :black,
        pawn: :black,
        king: :white,
        queen: :white,
        bishop: :white,
        knight: :white,
        rook: :white,
        pawn: :white
      ]
    )
  end

  describe "Piece.possible_moves/2" do
    test "starting position white pawn moves" do
      {:ok, game} = Game.new()
      assert Piece.possible_moves(game, {:a, 2}) == [a: 4, a: 3]
    end

    test "starting position black pawn moves" do
      {:ok, game} = Game.new()
      assert Piece.possible_moves(game, {:a, 7}) == [a: 5, a: 6]
    end

    test "starting position white rook moves" do
      {:ok, game} = Game.new()
      assert Piece.possible_moves(game, {:a, 1}) == []
      assert Piece.possible_moves(game, {:h, 1}) == []
    end

    test "starting position black rook moves" do
      {:ok, game} = Game.new()
      assert Piece.possible_moves(game, {:a, 8}) == []
      assert Piece.possible_moves(game, {:h, 8}) == []
    end

    test "starting position white knight moves" do
      {:ok, game} = Game.new()
      assert Piece.possible_moves(game, {:b, 1}) == [c: 3, a: 3]
      assert Piece.possible_moves(game, {:g, 1}) == [h: 3, f: 3]
    end

    test "starting position black knight moves" do
      {:ok, game} = Game.new()
      assert Piece.possible_moves(game, {:b, 8}) == [c: 6, a: 6]
      assert Piece.possible_moves(game, {:g, 8}) == [h: 6, f: 6]
    end

    test "starting position white bishop moves" do
      {:ok, game} = Game.new()
      assert Piece.possible_moves(game, {:c, 1}) == []
      assert Piece.possible_moves(game, {:f, 1}) == []
    end

    test "starting position black bishop moves" do
      {:ok, game} = Game.new()
      assert Piece.possible_moves(game, {:c, 8}) == []
      assert Piece.possible_moves(game, {:f, 8}) == []
    end

    test "starting position white queen moves" do
      {:ok, game} = Game.new()
      assert Piece.possible_moves(game, {:d, 1}) == []
    end

    test "starting position black queen moves" do
      {:ok, game} = Game.new()
      assert Piece.possible_moves(game, {:d, 8}) == []
    end

    test "starting position white king moves" do
      {:ok, game} = Game.new()
      assert Piece.possible_moves(game, {:e, 1}) == []
    end

    test "starting position black king moves" do
      {:ok, game} = Game.new()
      assert Piece.possible_moves(game, {:e, 8}) == []
    end
  end
end
