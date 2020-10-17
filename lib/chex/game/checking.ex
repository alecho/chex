defmodule Chex.Game.Checking do
  @moduledoc false

  alias Chex.{Game, Board, Color}

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

  @spec stalemate?(Game.t()) :: bool()
  def stalemate?(%{check: check}) when not is_nil(check), do: false

  def stalemate?(%{active_color: color} = game) do
    Board.all_possible_squares(game, color) == []
  end
end
