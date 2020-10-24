defmodule Chex.Piece.Rook do
  @moduledoc false

  @behaviour Chex.Piece

  import Chex.Piece.Movement

  @impl true
  def possible_moves(game, square, color) do
    walk(game, square, color, :n) ++
      walk(game, square, color, :s) ++
      walk(game, square, color, :e) ++
      walk(game, square, color, :w)
  end

  @impl true
  def attacking_squares(game, square, color), do: possible_moves(game, square, color)
end
