defmodule Chex.BoardTest do
  use ExUnit.Case, async: true
  import AssertValue
  doctest Chex.Board

  alias Chex.{Board, Game}

  @empty_board "8/8/8/4N3/8/8/8/8 w - - 0 1"

  test "file_offset" do
    results =
      for f <- [:a, :d, :h], o <- [-5, -1, 0, 4] do
        Board.file_offset(f, o)
      end

    assert_value(results == [nil, nil, :a, :e, nil, :c, :d, :h, :c, :g, :h, nil])
  end

  test "occupied_by_color" do
    results =
      for color <- [:white, :black], piece_color <- [:white, :black] do
        board = %{
          {:a, 1} => {:pawn, piece_color, {:a, 1}}
        }

        Chex.Board.occupied_by_color?(%{board: board}, color, {:a, 1})
      end

    assert_value(results == [true, false, false, true])
  end

  describe "Board.find_piece/2" do
    test "returns the square of the first matching piece" do
      {:ok, game} = Game.new()
      assert {:a, 2} == Board.find_piece(game, {:pawn, :white})
    end

    test "returns nil when the piece is not on the board" do
      {:ok, game} = Game.new(@empty_board)
      assert nil == Board.find_piece(game, {:pawn, :white})
    end
  end

  describe "Board.find_pieces/2" do
    test "returns squares of all matching pieces" do
      {:ok, game} = Game.new()

      assert [h: 2, g: 2, f: 2, e: 2, d: 2, c: 2, b: 2, a: 2] ==
               Board.find_pieces(game, {:pawn, :white})
    end

    test "returns an empty list when the piece is not on the board" do
      {:ok, game} = Game.new(@empty_board)
      assert [] == Board.find_pieces(game, {:pawn, :white})
    end
  end
end
