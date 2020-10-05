defmodule Chex.Piece.Rook do
  @moduledoc """
  Describe Rook moves.
  """
  @behaviour Chex.Piece

  import Chex.Piece.Movement

  @impl true
  def possible_moves(_color, square, game) do
    walk(game, square, :n) ++
      walk(game, square, :s) ++
      walk(game, square, :e) ++
      walk(game, square, :w)
  end

  @impl true
  def attacking_squares(color, square, game), do: possible_moves(color, square, game)
end
