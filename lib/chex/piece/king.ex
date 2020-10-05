defmodule Chex.Piece.King do
  alias Chex.{Board, Square}
  @behaviour Chex.Piece

  def possible_moves(color, {file, rank} = square, game) do
    moves =
      for r <- [-1, 0, 1], f <- [-1, 0, 1] do
        {Board.file_offset(file, f), rank + r}
      end
      |> List.delete(square)
      |> Enum.filter(&Square.valid?(&1))
      |> Enum.reject(&Board.occupied_by_color?(game.board, color, &1))

    opponent_color = if color == :white, do: :black, else: :white
    moves -- Board.all_attacking_sqaures(game.board, opponent_color, game)
  end

  def attacking_squares(_color, {file, rank} = square, _game) do
    for r <- [-1, 0, 1], f <- [-1, 0, 1] do
      {Board.file_offset(file, f), rank + r}
    end
    |> List.delete(square)
    |> Enum.filter(&Square.valid?(&1))
  end
end
