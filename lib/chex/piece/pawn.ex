defmodule Chex.Piece.Pawn do
  @moduledoc false

  @behaviour Chex.Piece

  import Chex.Board, only: [occupied_by_color?: 3, occupied?: 2, file_offset: 2]
  import Chex.Square, only: [valid?: 1]
  import Chex.Piece.Movement, only: [walk: 6]

  @impl true
  def possible_moves(game, square, color) do
    moves =
      moves(game, color, square)
      |> Enum.reject(&occupied?(game, &1))

    attacks =
      attacking_squares(game, square, color)
      |> Enum.filter(&occupied?(game, &1))
      |> Enum.reject(&occupied_by_color?(game, color, &1))

    moves ++ attacks
  end

  @impl true
  def attacking_squares(_game, square, color) do
    attacks(color, square)
    |> Enum.filter(&valid?(&1))
  end

  defp moves(game, :white, {_, 2} = sq), do: walk(game, [], sq, :white, :n, 2)
  defp moves(game, :white, sq), do: walk(game, [], sq, :white, :n, 1)
  defp moves(game, :black, {_, 7} = sq), do: walk(game, [], sq, :black, :s, 2)
  defp moves(game, :black, sq), do: walk(game, [], sq, :black, :s, 1)

  defp attacks(:white, {file, rank}) do
    [{file_offset(file, -1), rank + 1}, {file_offset(file, 1), rank + 1}]
  end

  defp attacks(:black, {file, rank}) do
    [{file_offset(file, -1), rank - 1}, {file_offset(file, 1), rank - 1}]
  end
end
