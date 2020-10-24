defmodule Chex.Board do
  @moduledoc false

  @type value :: {Chex.name(), Chex.color(), Chex.square()}

  @files [:a, :b, :c, :d, :e, :f, :g, :h]
  # @ranks 1..8

  @starting_position %{
    {:a, 1} => {:rook, :white, {:a, 1}},
    {:a, 2} => {:pawn, :white, {:a, 2}},
    {:a, 7} => {:pawn, :black, {:a, 7}},
    {:a, 8} => {:rook, :black, {:a, 8}},
    {:b, 1} => {:knight, :white, {:b, 1}},
    {:b, 2} => {:pawn, :white, {:b, 2}},
    {:b, 7} => {:pawn, :black, {:b, 7}},
    {:b, 8} => {:knight, :black, {:b, 8}},
    {:c, 1} => {:bishop, :white, {:c, 1}},
    {:c, 2} => {:pawn, :white, {:c, 2}},
    {:c, 7} => {:pawn, :black, {:c, 7}},
    {:c, 8} => {:bishop, :black, {:c, 8}},
    {:d, 1} => {:queen, :white, {:d, 1}},
    {:d, 2} => {:pawn, :white, {:d, 2}},
    {:d, 7} => {:pawn, :black, {:d, 7}},
    {:d, 8} => {:queen, :black, {:d, 8}},
    {:e, 1} => {:king, :white, {:e, 1}},
    {:e, 2} => {:pawn, :white, {:e, 2}},
    {:e, 7} => {:pawn, :black, {:e, 7}},
    {:e, 8} => {:king, :black, {:e, 8}},
    {:f, 1} => {:bishop, :white, {:f, 1}},
    {:f, 2} => {:pawn, :white, {:f, 2}},
    {:f, 7} => {:pawn, :black, {:f, 7}},
    {:f, 8} => {:bishop, :black, {:f, 8}},
    {:g, 1} => {:knight, :white, {:g, 1}},
    {:g, 2} => {:pawn, :white, {:g, 2}},
    {:g, 7} => {:pawn, :black, {:g, 7}},
    {:g, 8} => {:knight, :black, {:g, 8}},
    {:h, 1} => {:rook, :white, {:h, 1}},
    {:h, 2} => {:pawn, :white, {:h, 2}},
    {:h, 7} => {:pawn, :black, {:h, 7}},
    {:h, 8} => {:rook, :black, {:h, 8}}
  }

  @spec get_piece_name(Chex.game(), Chex.square()) :: Chex.name() | nil
  def get_piece_name(%{board: board}, square) do
    case board[square] do
      {name, _color, _sq} -> name
      _ -> nil
    end
  end

  @spec get_piece_color(Chex.game(), Chex.square()) :: Chex.color() | nil
  def get_piece_color(%{board: board}, square) do
    case board[square] do
      {_name, color, _sq} -> color
      _ -> nil
    end
  end

  @spec pickup_piece(Chex.game(), Chex.square()) ::
          {:ok, {value(), Chex.game()}} | {:error, :reason}
  def pickup_piece(game, square) do
    case Map.pop(game.board, square) do
      {nil, _board} -> {:error, :no_piece_at_square}
      {piece, board} -> {:ok, {piece, %{game | board: board}}}
    end
  end

  @spec place_piece(Chex.game(), Chex.square(), value()) ::
          {:ok, {value(), Chex.game()}} | {:error, :reason}
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

  @spec move(Chex.game(), Chex.square(), Chex.square()) ::
          {:ok, {value(), value(), Chex.game()}} | {:error, :reason}
  def move(game, from, to) do
    with {:ok, {piece, game}} <- pickup_piece(game, from),
         {:ok, {capture, game}} <- place_piece(game, to, piece) do
      {:ok, {piece, capture, game}}
    end
  end

  def starting_position, do: @starting_position

  def files, do: @files

  def file_index(file), do: Enum.find_index(@files, fn x -> x == file end)

  def file_offset(file, 0), do: file

  def file_offset(file, offset) do
    offset_index = file_index(file)

    index = offset_index + offset

    # Prevent wrap-around. Ex: (:a, -2) => :h
    if index >= 0, do: Enum.at(@files, index)
  end

  def occupied_by_color?(%{board: board}, color, square) do
    case board[square] do
      {_name, ^color, _sq} -> true
      _ -> false
    end
  end

  def occupied?(%{board: board}, square) do
    !is_nil(board[square])
  end

  @doc """
  Get the square of the first matching piece.
  """
  @spec find_piece(Chex.game(), Chex.piece()) :: Chex.square() | nil
  def find_piece(%{board: board}, piece) do
    Enum.reduce_while(board, nil, &finder(piece, &1, &2))
  end

  defp finder({name, color}, {square, {name, color, _}}, _acc), do: {:halt, square}

  defp finder(_piece, {_square, _value}, acc), do: {:cont, acc}

  @doc """
  Find locations of the specified piece on the board.
  """
  @spec find_pieces(Chex.game(), Chex.piece()) :: [Chex.square()] | []
  def find_pieces(%{board: board}, piece) do
    Enum.reduce(board, [], fn {square, {n, c, _}}, acc ->
      if {n, c} == piece, do: [square | acc], else: acc
    end)
  end

  def all_attacking_squares(game, color) do
    game
    |> all_occupied_by_color(color)
    |> Enum.map(&Chex.Piece.attacking_squares(game, &1))
    |> List.flatten()
    |> Enum.uniq()
  end

  def all_possible_squares(game, color) do
    game
    |> all_occupied_by_color(color)
    |> Enum.map(&Chex.Piece.possible_moves(game, &1))
    |> List.flatten()
    |> Enum.uniq()
  end

  def all_occupied_by_color(%{board: board}, color) do
    board
    |> Enum.map(fn {k, _v} -> k end)
    |> Enum.filter(&occupied_by_color?(%{board: board}, color, &1))
  end
end
