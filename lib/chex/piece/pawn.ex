defmodule Chex.Piece.Pawn do
  alias Chex.{Board, Square}
  @behaviour Chex.Piece

  def possible_moves(_color, _square = {_file, _rank}, _game), do: []

  def attacking_squares(_color, _square = {_file, _rank}, _ep), do: []
end
