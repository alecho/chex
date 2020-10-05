defmodule Chex.Piece.Movement do
  @moduledoc """
  Piece movement helper functions.
  """
  alias Chex.{Board, Square}

  @typedoc """
  A direction atom.
  """
  @type direction :: :n | :s | :e | :w | :ne | :se | :nw | :sw

  def walk(game, square, dir) do
    walk(game, [], square, dir, 7)
  end

  def walk(game, squares, square, dir, limit \\ 7)

  def walk(_game, squares, _square, _dir, 0), do: squares

  def walk(game, squares, square, dir, limit) do
    new_sq = next_square(square, dir)
    {squares, limit} = prepare_arguments(game, squares, new_sq, limit)

    walk(game, squares, new_sq, dir, limit)
  end

  defp next_square({file, rank}, dir) do
    {f_dir, r_dir} = directions()[dir]
    sq = {Board.file_offset(file, f_dir), rank + r_dir}
    if Square.valid?(sq), do: sq, else: nil
  end

  defp prepare_arguments(_game, squares, nil, _limit), do: {squares, 0}

  defp prepare_arguments(game, squares, new_sq, limit) do
    occupied_by_enemy = !Board.occupied_by_color?(game.board, game.active_color, new_sq)
    squares = maybe_add_square(squares, new_sq, occupied_by_enemy)
    occupied = Board.occupied?(game.board, new_sq)
    limit = occupied_limit(limit, occupied)

    {squares, limit}
  end

  defp maybe_add_square(squares, square, true), do: [square | squares]
  defp maybe_add_square(squares, _square, _occupied), do: squares

  defp occupied_limit(_limit, true), do: 0
  defp occupied_limit(limit, _occupied), do: limit - 1

  defp directions do
    [
      n: {0, 1},
      s: {0, -1},
      e: {1, 0},
      w: {-1, 0},
      ne: {1, 1},
      se: {1, -1},
      nw: {-1, 1},
      sw: {-1, -1}
    ]
  end
end
