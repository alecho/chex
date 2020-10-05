defmodule Chex.Piece.Rook do
  @moduledoc """
  Describe Rook moves.
  """
  @behaviour Chex.Piece

  import Chex.Piece.Movement

  @impl true
  def possible_moves(color, square, game) do
    walk(game, square, color, :n) ++
      walk(game, square, color, :s) ++
      walk(game, square, color, :e) ++
      walk(game, square, color, :w)
  end

  @impl true
  def attacking_squares(color, square, game), do: possible_moves(color, square, game)
end
