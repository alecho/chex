defmodule Chex.Game.Checking do
  @moduledoc false

  alias Chex.{Board, Color}

  @spec in_check?(Chex.game(), Chex.color()) :: bool()
  def in_check?(game, color) do
    square = Board.find_piece(game, {:king, color})

    Board.all_attacking_squares(game, Color.flip(color))
    |> Enum.member?(square)
  end

  @spec checkmate?(Chex.game()) :: bool()
  def checkmate?(%{active_color: color} = game) do
    in_check?(game, color) && Board.all_possible_squares(game, color) == []
  end

  @spec stalemate?(Chex.game()) :: bool()
  def stalemate?(%{check: check}) when not is_nil(check), do: false

  def stalemate?(%{active_color: color} = game) do
    Board.all_possible_squares(game, color) == []
  end
end
