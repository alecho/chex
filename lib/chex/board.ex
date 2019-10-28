defmodule Chex.Board do
  import Map, only: [get_and_update: 3]
  import Enum, only: [reduce: 3]

  alias Chex.Square

  defstruct []

  @files [:a, :b, :c, :d, :e, :f, :g, :h]
  @ranks 1..8

  def new() do
    for f <- @files, r <- @ranks do
      {f, r}
    end
    |> reduce(%__MODULE__{}, fn key, map -> Map.put(map, key, nil) end)
  end

  def place_at(%__MODULE__{} = board, square, new_piece) do
    board
    |> get_and_update(square, fn current_piece ->
      {current_piece, new_piece}
    end)
  end

  @spec get(%Chex.Board{}, Square.t()) :: term | nil
  def get(%__MODULE__{} = board, square) do
    board |> Map.get(square)
  end

  def files(), do: @files

  def file_index(file), do: Enum.find_index(@files, fn x -> x == file end)

  def file_offset(file, 0), do: file

  def file_offset(file, offset) do
    offset_index =
      file
      |> file_index

    index = offset_index + offset

    # Prevent wrap-around. Ex: (:a, -2) => :h
    if index >= 0, do: Enum.at(@files, index)
  end

  def occupied_by_color?(board, color, square) do
    case Map.get(board, square) do
      {_name, occupied_color, _sq} ->
        color == occupied_color

      nil ->
        false
    end
  end
end
