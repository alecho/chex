defmodule Chex.Game do
  @moduledoc """
  Functions for playing a chess game.
  """

  defstruct board: Chex.Board.new(),
            active_color: :white,
            castling: [:K, :Q, :k, :q],
            en_passant: nil,
            moves: [],
            halfmove_clock: 0,
            fullmove_clock: 0,
            fen: '',
            captures: []

  @type t() :: %__MODULE__{}
  @type move() :: {Chex.Square.t(), Chex.Square.t()}

  @starting_pos "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

  @doc """
  Creates a new game from `fen`.

  Returns a %Chex.Game{} initialized with fen or the default starting positions.

  ## Examples

  iex> Chex.Game.new()
  %Chex.Game{}
  iex> Chex.Game.new("rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
  %Chex.Game{}

  """
  @spec new(String.t()) :: Chex.Game.t()
  def new(fen \\ @starting_pos) do
    Chex.Parser.FEN.parse(fen)
    |> update_fen()
  end

  @spec move(Chex.Game.t(), Chex.Game.move() | String.t()) :: Chex.Game.t() | {:error, atom}
  def move(game, move) when byte_size(move) == 4 do
    {from, to} = String.split_at(move, 2)
    move(game, {Chex.Square.from_string(from), Chex.Square.from_string(to)})
  end

  def move(game, {from, to} = move) do
    with true <- move_valid?(game, move),
         {:ok, {piece, game}} <- pickup_piece(game, from),
         {:ok, {capture, game}} <- place_piece(game, to, piece) do
      game =
        game
        |> add_move(move)
        |> capture_piece(capture)
        |> switch_active_color()
        |> update_castling(piece)
        |> update_halfmove_clock(piece, capture)
        |> update_fullmove_clock(piece)
        |> update_fen()

      {:ok, game}
    end
  end

  @spec add_move(Chex.Game.t(), Chex.Game.move()) :: Chex.Game.t()
  defp add_move(%Chex.Game{moves: moves} = game, move) do
    game
    |> Map.put(:moves, [move | moves])
  end

  @spec update_fullmove_clock(Chex.Game.t(), Chex.Piece.t()) :: Chex.Game.t()
  defp update_fullmove_clock(game, {_name, :black}) do
    {_old, game} =
      game
      |> Map.get_and_update(:fullmove_clock, fn clock ->
        {clock, clock + 1}
      end)

    game
  end

  defp update_fullmove_clock(game, _piece), do: game

  @spec update_castling(Chex.Game.t(), Chex.Piece.t()) :: Chex.Game.t()
  defp update_castling(game, {:king, :black}) do
    delete_castling_rights(game, [:k, :q])
  end

  defp update_castling(game, {:king, :white}) do
    delete_castling_rights(game, [:K, :Q])
  end

  defp update_castling(game, {:rook, color}) do
    [{{from_file, _rank}, _to} | _prev_moves] = game |> Map.get(:moves)

    name =
      case from_file do
        :a ->
          :queen

        :h ->
          :king
      end

    right =
      {name, color}
      |> Chex.Piece.to_string()
      |> String.to_existing_atom()

    delete_castling_rights(game, [right])
  end

  defp update_castling(game, _piece), do: game

  defp delete_castling_rights(game, rights) when is_list(rights) do
    {_old, game} =
      game
      |> Map.get_and_update(:castling, fn current_rights ->
        {current_rights, current_rights -- rights}
      end)

    game
  end

  @spec update_halfmove_clock(Chex.Game.t(), Chex.Piece.t(), Chex.Piece.t() | nil) ::
          Chex.Game.t()
  defp update_halfmove_clock(game, {piece_name, _color}, capture)
       when piece_name == :pawn or not is_nil(capture) do
    {_old, game} =
      game
      |> Map.get_and_update(:halfmove_clock, fn clock ->
        {clock, clock + 1}
      end)

    game
  end

  defp update_halfmove_clock(game, _piece, _capture), do: game

  @spec to_fen(Chex.Game.t()) :: String.t()
  def to_fen(%Chex.Game{} = game) do
    Chex.Parser.FEN.serialize(game)
  end

  @spec move_valid?(Chex.Game.t(), {Chex.Square.t(), Chex.Square.t()}) ::
          boolean() | {:error, reason :: atom}
  defp move_valid?(%Chex.Game{} = game, {from, _to}) do
    with {:ok, _piece} <- piece_at(game, from), do: true
  end

  defp pickup_piece(game, square) do
    game
    |> Map.get(:board)
    |> Map.get_and_update(square, fn piece ->
      {piece, nil}
    end)
    |> case do
      {nil, _board} ->
        {:error, :no_piece_at_square}

      {piece, board} ->
        game =
          game
          |> Map.put(:board, board)

        {:ok, {piece, game}}
    end
  end

  defp place_piece(game, square, piece) do
    {capture, board} =
      game
      |> Map.get(:board)
      |> Map.get_and_update(square, fn capture ->
        {capture, piece}
      end)

    game =
      game
      |> Map.put(:board, board)

    {:ok, {capture, game}}
  end

  # defp prepend_move(game, from, to)
  # defp move_piece(game, from, to) do
  # end

  @spec update_fen(Chex.Game.t()) :: Chex.Game.t()
  defp update_fen(%Chex.Game{} = game) do
    game
    |> Map.put(:fen, to_fen(game))
  end

  # defp switch_active_color
  @spec switch_active_color(Chex.Game.t()) :: Chex.Game.t()
  defp switch_active_color(%Chex.Game{active_color: :white} = game) do
    game |> Map.put(:active_color, :black)
  end

  defp switch_active_color(%Chex.Game{active_color: :black} = game) do
    game |> Map.put(:active_color, :white)
  end

  defp piece_at(game, square) do
    game
    |> Map.get(:board)
    |> Map.get(square)
    |> case do
      nil ->
        {:error, :no_piece_at_square}

      piece ->
        {:ok, piece}
    end
  end

  @spec capture_piece(Chex.Game.t(), Chex.Piece.t() | nil) :: Chex.Game.t()
  defp capture_piece(game, nil), do: game

  defp capture_piece(%Chex.Game{captures: captures} = game, piece) do
    Map.put(game, :captures, [piece | captures])
  end
end
