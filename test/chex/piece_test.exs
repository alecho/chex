defmodule Chex.PieceTest do
  use ExUnit.Case
  import AssertValue
  doctest Chex.Piece

  test "correctly parses pieces" do
    results =
      "kqbnrpKQBNRP"
      |> String.codepoints()
      |> Enum.map(fn str ->
        Chex.Piece.from_string(str)
      end)

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
