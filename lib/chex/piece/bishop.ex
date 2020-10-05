defmodule Chex.Piece.Bishop do
  @behaviour Chex.Piece

  import Chex.Piece.Movement

  @impl true
  def possible_moves(color, square, game) do
    walk(game, square, color, :ne) ++
      walk(game, square, color, :se) ++
      walk(game, square, color, :sw) ++
      walk(game, square, color, :nw)
  end

  @impl true
  def attacking_squares(color, square, game), do: possible_moves(color, square, game)
end
