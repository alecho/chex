defmodule Chex.Piece.King do
  alias Chex.Board
  @behaviour Chex.Piece

  def possible_moves(color, square = {file, rank}, game) do
    for r <- [-1, 0, 1], f <- [-1, 0, 1] do
      {Board.file_offset(file, f), rank + r}
    end
    |> List.delete(square)
  end
end
