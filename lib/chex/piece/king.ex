defmodule Chex.Piece.King do
  @moduledoc """
  Describes King moves.
  """
  alias Chex.{Board, Color, Piece, Square}
  @behaviour Piece

  def possible_moves(color, square, game) do
    moves =
      possible_squares(square)
      |> Enum.reject(&Board.occupied_by_color?(game.board, color, &1))
      |> maybe_prepend_castling(game, color)

    moves -- Board.all_attacking_sqaures(game.board, Color.flip(color), game)
  end

  def attacking_squares(_color, square, _game), do: possible_squares(square)

  defp maybe_prepend_castling(moves, %{check: c}, c), do: moves
  defp maybe_prepend_castling(moves, %{castling: []}, _color), do: moves

  defp maybe_prepend_castling(moves, game, color) do
    rank = rank_for_color(color)

    moves
    |> maybe_add_move({:g, rank}, can_kingside_castle(game, color))
    |> maybe_add_move({:c, rank}, can_queenside_castle(game, color))
  end

  defp maybe_add_move(moves, square, true), do: [square | moves]
  defp maybe_add_move(moves, _square, _false), do: moves

  defp possible_squares({file, rank} = square) do
    for r <- [-1, 0, 1], f <- [-1, 0, 1] do
      {Board.file_offset(file, f), rank + r}
    end
    |> List.delete(square)
    |> Enum.filter(&Square.valid?(&1))
  end

  defp piece_to_right(name, color) do
    Piece.to_string({name, color})
    |> String.to_existing_atom()
  end

  defp rank_for_color(:white), do: 1
  defp rank_for_color(:black), do: 8

  defp kingside_squares(color) do
    r = rank_for_color(color)
    [f: r, g: r]
  end

  defp queenside_squares(color, for \\ :occupied)

  defp queenside_squares(color, :occupied) do
    r = rank_for_color(color)
    [d: r, c: r, b: r]
  end

  defp queenside_squares(color, :attacking) do
    r = rank_for_color(color)
    [d: r, c: r]
  end

  defp can_kingside_castle(game, color) do
    squares = kingside_squares(color)
    attacked_squares = Board.all_attacking_sqaures(game.board, Color.flip(color), game)

    occupied = Enum.any?(squares, &Board.occupied?(game.board, &1))
    attacked = Enum.any?(squares, fn sq -> sq in attacked_squares end)
    has_right = piece_to_right(:king, color) in game.castling

    !occupied && !attacked && has_right
  end

  defp can_queenside_castle(game, color) do
    attacked_squares = Board.all_attacking_sqaures(game.board, Color.flip(color), game)

    occupied =
      queenside_squares(color)
      |> Enum.any?(&Board.occupied?(game.board, &1))

    attacked =
      queenside_squares(color, :attacking)
      |> Enum.any?(fn sq -> sq in attacked_squares end)

    has_right = piece_to_right(:queen, color) in game.castling

    !occupied && !attacked && has_right
  end
end
