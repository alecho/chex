defmodule Chex.Game.Checking do
  @moduledoc """
  Functions for working with checking and mate.
  """

  alias Chex.{Board, Color}

  @spec in_check?(Game.t(), Color.t()) :: bool()
  def in_check?(game, color) do
    square = Board.find_piece(game, {:king, color})

    Board.all_attacking_squares(game, Color.flip(color))
    |> Enum.member?(square)
  end

  @spec checkmate?(Game.t()) :: bool()
  def checkmate?(%{active_color: color} = game) do
    in_check?(game, color) && Board.all_possible_squares(game, color) == []
  end
end
