defmodule Chex.Piece.Knight do
  @moduledoc """
  Describe Knight moves.
  """
  @behaviour Chex.Piece

  alias Chex.{Board, Square}

  @directions [
    {2, 1},
    {2, -1},
    {-2, 1},
    {-2, -1},
    {1, 2},
    {1, -2},
    {-1, 2},
    {-1, -2}
  ]

  @impl true
  def possible_moves(color, {file, rank}, game) do
    Enum.map(@directions, fn {f_dir, r_dir} ->
      {Board.file_offset(file, f_dir), rank + r_dir}
    end)
    |> Enum.filter(&Square.valid?(&1))
    |> Enum.reject(&Board.occupied_by_color?(game, color, &1))
  end

  @impl true
  def attacking_squares(color, square, game), do: possible_moves(color, square, game)
end
