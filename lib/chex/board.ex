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

  def occupied?(board, square) do
    !is_nil(Map.get(board, square))
  end

  @doc """
  Get the square of the first matching piece.
  """
  @spec find_piece(%Chex.Board{}, Piece.t()) :: Square.t() | nil
  def find_piece(board, piece) do
    board
    |> Map.from_struct()
    |> Enum.reduce_while(nil, fn {square, {n, c, _}}, acc ->
      if {n, c} == piece, do: {:halt, square}, else: {:cont, acc}
    end)
  end

  @doc """
  Find locations of the specified piece on the board.
  """
  @spec find_pieces(%Chex.Board{}, Piece.t()) :: [Square.t()] | []
  def find_pieces(board, piece) do
    board
    |> Map.from_struct()
    |> Enum.reduce([], fn {square, {n, c, _}}, acc ->
      if {n, c} == piece, do: [square | acc], else: acc
    end)
  end

  def all_attacking_sqaures(board, color, game) do
    board
    |> all_occupied_by_color(color)
    |> Enum.map(fn square ->
      {name, _occupied_color, sq} = Map.get(board, square)
      Chex.Piece.attacking_squares({name, color}, sq, game)
    end)
    |> List.flatten()
    |> Enum.uniq()
  end

  def all_possible_squares(game, color) do
    game.board
    |> all_occupied_by_color(color)
    |> Enum.map(&Chex.Piece.possible_moves(game, &1))
    |> List.flatten()
    |> Enum.uniq()
  end

  def all_occupied_by_color(board, color) do
    board
    |> Map.from_struct()
    |> Enum.map(fn {k, _v} -> k end)
    |> Enum.filter(&occupied_by_color?(board, color, &1))
  end
end
