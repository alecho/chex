defmodule Chex.Board do
  @moduledoc """
  Chess board functions.
  """
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
  def get(%{} = board, square) do
    board |> Map.get(square)
  end

  @spec get_piece_name(%Chex.Board{}, Square.t()) :: Piece.name() | nil
  def get_piece_name(%{} = board, square) do
    board
    |> get(square)
    |> extract_piece_name()
  end

  defp extract_piece_name({name, _c, _id}), do: name
  defp extract_piece_name(_pice), do: nil

  @spec pickup_piece(Game.t(), Square.t()) :: {:ok, {Piece.t(), Game.t()}} | {:error, :reason}
  def pickup_piece(game, square) do
    game.board
    |> Map.get_and_update(square, fn piece ->
      {piece, nil}
    end)
    |> case do
      {nil, _board} ->
        {:error, :no_piece_at_square}

      {piece, board} ->
        {:ok, {piece, %{game | board: board}}}
    end
  end

  @spec place_piece(Game.t(), Square.t(), Piece.t()) ::
          {:ok, {Piece.t(), Game.t()}} | {:error, :reason}
  def place_piece(game, square, {_name, color, _start} = piece) do
    game.board
    |> Map.get_and_update(square, fn capture ->
      {capture, piece}
    end)
    |> case do
      {{_name, ^color, _start}, _board} ->
        {:error, :occupied_by_own_color}

      {capture, board} ->
        {:ok, {capture, %{game | board: board}}}
    end
  end

  @spec move(Game.t(), Square.t(), Square.t()) ::
          {:ok, {Piece.t(), Piece.t(), Game.t()}} | {:error, :reason}
  def move(game, from, to) do
    with {:ok, {piece, game}} <- pickup_piece(game, from),
         {:ok, {capture, game}} <- place_piece(game, to, piece) do
      {:ok, {piece, capture, game}}
    end
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
    |> Enum.reduce_while(nil, &finder(piece, &1, &2))
  end

  defp finder({name, color}, {square, {name, color, _}}, _acc), do: {:halt, square}

  defp finder(_piece, {_square, _value}, acc), do: {:cont, acc}

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

  def all_attacking_squares(game, color) do
    game.board
    |> all_occupied_by_color(color)
    |> Enum.map(fn square ->
      {name, _occupied_color, _sq} = Map.get(game.board, square)
      Chex.Piece.attacking_squares({name, color}, square, game)
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
