defmodule Chex.FullGameCase do
  use ExUnit.CaseTemplate

  import Chex.Parser.PGN, only: [movetext: 1]

  def set_context(moves) do
    {:ok, moves, _, _, _, _} = movetext(moves)
    [moves: moves, game: Chex.new_game!()]
  end

  using do
    quote do
      import Chex.FullGameCase
      import Chex.Game, only: [moves: 2]
    end
  end
end
