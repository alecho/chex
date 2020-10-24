defmodule Chex.Piece.Knight do
  @moduledoc false

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
  def possible_moves(game, {file, rank}, color) do
    Enum.map(@directions, fn {f_dir, r_dir} ->
      {Board.file_offset(file, f_dir), rank + r_dir}
    end)
    |> Enum.filter(&Square.valid?(&1))
    |> Enum.reject(&Board.occupied_by_color?(game, color, &1))
  end

  @impl true
  def attacking_squares(game, square, color), do: possible_moves(game, square, color)
end
