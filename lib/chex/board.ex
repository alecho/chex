defmodule Chex.Board do
  import Map, only: [get_and_update!: 3]
  import Enum, only: [reduce: 3]

  defstruct []

  @files [:a, :b, :c, :d, :e, :f, :g, :h]
  @ranks 1..8

  def new() do
    for f <- @files, r <- @ranks do
      {f, r}
    end
    |> reduce(%__MODULE__{}, fn key, map -> Map.put(map, key, nil) end)
  end

  def place_at!(%__MODULE__{} = board, square, new_piece) when is_list(square) do
    board
    |> get_and_update!(square, fn current_piece ->
      {current_piece, new_piece}
    end)
  end
end
