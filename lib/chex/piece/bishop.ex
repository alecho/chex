defmodule Chex.Piece.Bishop do
  @moduledoc false

  @behaviour Chex.Piece

  import Chex.Piece.Movement

  @impl true
  def possible_moves(game, square, color) do
    walk(game, square, color, :ne) ++
      walk(game, square, color, :se) ++
      walk(game, square, color, :sw) ++
      walk(game, square, color, :nw)
  end

  @impl true
  def attacking_squares(game, square, color), do: possible_moves(game, square, color)
end
