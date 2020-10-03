defmodule Chex.Game.Checking do
  @moduledoc """
  Functions for working with checking and mate.
  """

  alias Chex.{Board, Color}

  def in_check?(game, color) do
    square = Board.find_piece(game.board, {:king, color})

    Board.all_attacking_sqaures(game.board, Color.flip(color), game)
    |> Enum.member?(square)
  end

  def checkmate?(%{active_color: color} = game) do
    in_check?(game, color) && Board.all_possible_squares(game, color) == []
  end
end
