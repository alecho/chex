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
end
