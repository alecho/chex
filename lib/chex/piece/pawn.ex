defmodule Chex.Piece.Pawn do
  @moduledoc false

  @behaviour Chex.Piece

  import Chex.Board, only: [occupied_by_color?: 3, occupied?: 2, file_offset: 2]
  import Chex.Square, only: [valid?: 1]
  import Chex.Color, only: [flip: 1]

  @impl true
  def possible_moves(color, square, game) do
    moves =
      moves(color, square)
      |> Enum.reject(&occupied_by_color?(game, flip(color), &1))

    attacks =
      attacking_squares(color, square, game)
      |> Enum.filter(&occupied?(game, &1))
      |> Enum.reject(&occupied_by_color?(game, color, &1))

    moves ++ attacks
  end

  @impl true
  def attacking_squares(color, square, _game) do
    attacks(color, square)
    |> Enum.filter(&valid?(&1))
  end

  defp moves(:white, {file, 2}), do: [{file, 3}, {file, 4}]
  defp moves(:white, {file, rank}), do: [{file, rank + 1}]
  defp moves(:black, {file, 7}), do: [{file, 6}, {file, 5}]
  defp moves(:black, {file, rank}), do: [{file, rank - 1}]

  defp attacks(:white, {file, rank}) do
    [{file_offset(file, -1), rank + 1}, {file_offset(file, 1), rank + 1}]
  end

  defp attacks(:black, {file, rank}) do
    [{file_offset(file, -1), rank - 1}, {file_offset(file, 1), rank - 1}]
  end
end
