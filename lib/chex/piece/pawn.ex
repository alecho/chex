defmodule Chex.Piece.Pawn do
  @behaviour Chex.Piece

  def possible_moves(color, square, _game) do
    moves(color, square)
  end

  def attacking_squares(_color, _square = {_file, _rank}, _ep \\ nil),
    do: []

  defp moves(:white, {file, 2}), do: [{file, 3}, {file, 4}]
  defp moves(:white, {file, rank}), do: [{file, rank + 1}]
  defp moves(:black, {file, 7}), do: [{file, 6}, {file, 5}]
  defp moves(:black, {file, rank}), do: [{file, rank - 1}]
end
