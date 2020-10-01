defmodule Chex.PieceTest do
  use ExUnit.Case, asyc: true
  import AssertValue
  doctest Chex.Piece

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
end
