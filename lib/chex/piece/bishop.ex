defmodule Chex.Piece.Bishop do
  @behaviour Chex.Piece

  import Chex.Piece.Movement

  @impl true
  def possible_moves(_color, square, game) do
    walk(game, square, :ne) ++
      walk(game, square, :se) ++
      walk(game, square, :sw) ++
      walk(game, square, :nw)
  end

  @impl true
  def attacking_squares(color, square, game), do: possible_moves(color, square, game)
end
