defmodule Chex.BoardTest do
  use ExUnit.Case
  import AssertValue
  doctest Chex.Board

  alias Chex.Board

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
        Chex.Board.new()
        |> Map.put({:a, 1}, {:pawn, piece_color, {:a, 1}})
        |> Chex.Board.occupied_by_color?(color, {:a, 1})
      end

    assert_value(results == [true, false, false, true])
  end
end
