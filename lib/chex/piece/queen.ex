defmodule Chex.Piece.Queen do
  @behaviour Chex.Piece

  import Chex.Piece.Movement

  @impl true
  def possible_moves(color, square, game) do
    walk(game, square, color, :n) ++
      walk(game, square, color, :s) ++
      walk(game, square, color, :e) ++
      walk(game, square, color, :w) ++
      walk(game, square, color, :ne) ++
      walk(game, square, color, :se) ++
      walk(game, square, color, :nw) ++
      walk(game, square, color, :sw)
  end

  @impl true
  def attacking_squares(color, square, game), do: possible_moves(color, square, game)
end
