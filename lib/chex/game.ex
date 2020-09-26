defmodule Chex.Game do
  @moduledoc """
  Functions for playing a chess game.
  """

  alias Chex.{Board, Game, Piece, Square}

  defstruct board: Board.new(),
            active_color: :white,
            castling: [:K, :Q, :k, :q],
            en_passant: nil,
            moves: [],
            halfmove_clock: 0,
            fullmove_clock: 0,
            captures: []

  @type t() :: %__MODULE__{}

  @starting_pos "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

  @doc """
  Creates a new game from `fen`.

  Returns a %Game{} initialized with fen or the default starting positions.

  ## Examples

  iex> Chex.Game.new()
  %Chex.Game{}
  iex> Chex.Game.new("rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
  %Chex.Game{}

  """
  @spec new(String.t()) :: {:ok, Game.t()} | {:error, atom()}
  def new(fen \\ @starting_pos), do: Chex.Parser.FEN.parse(fen)

  @spec move(Game.t(), {Square.t(), Square.t()} | String.t()) ::
          {:ok, Game.t()} | {:error, :no_piece_at_square}
  def move(game, move) when byte_size(move) == 4 do
    {from, to} = String.split_at(move, 2)
    move(game, {Square.from_string(from), Square.from_string(to)})
  end

  def move(game, {from, to} = move) do
    with true <- move_valid?(game, move),
         {:ok, {piece, game}} <- pickup_piece(game, from),
         {:ok, {capture, game}} <- place_piece(game, to, piece) do
      game =
        game
        |> add_move(move)
        |> capture_piece(capture)
        # |> promote_pawn()
        |> switch_active_color()
        |> update_castling(piece)
        |> update_en_passant(piece)
        |> update_halfmove_clock(piece, capture)
        |> maybe_increment_fullmove_clock(piece)

      {:ok, game}
    end
  end

  @spec add_move(Game.t(), {Square.t(), Square.t()}) :: Game.t()
  defp add_move(%Game{moves: moves} = game, move) do
    game
    |> Map.put(:moves, [move | moves])
  end

  @spec maybe_increment_fullmove_clock(Game.t(), Piece.t()) :: Game.t()
  defp maybe_increment_fullmove_clock(game, {_name, :black}) do
    {_old, game} =
      game
      |> Map.get_and_update(:fullmove_clock, fn clock ->
        {clock, clock + 1}
      end)

    game
  end

  defp maybe_increment_fullmove_clock(game, _piece), do: game

  @spec update_castling(Game.t(), Piece.t()) :: Game.t()
  defp update_castling(game, {:king, :black}) do
    delete_castling_rights(game, [:k, :q])
  end

  defp update_castling(game, {:king, :white}) do
    delete_castling_rights(game, [:K, :Q])
  end

  defp update_castling(%{moves: [{{:a, _r}, _to} | _tl]} = game, {:rook, color}) do
    right =
      {:queen, color}
      |> Piece.to_string()
      |> String.to_existing_atom()

    delete_castling_rights(game, [right])
  end

  defp update_castling(%{moves: [{{:h, _r}, _to} | _tl]} = game, {:rook, color}) do
    right =
      {:king, color}
      |> Piece.to_string()
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

  @spec update_en_passant(Game.t(), Piece.t()) :: Game.t()
  defp update_en_passant(
         %Game{moves: [{{file, 2}, {file, 4}} | _prev_moves]} = game,
         {:pawn, :white}
       ) do
    Map.put(game, :en_passant, {file, 3})
  end

  defp update_en_passant(
         %Game{moves: [{{file, 7}, {file, 5}} | _prev_moves]} = game,
         {:pawn, :black}
       ) do
    Map.put(game, :en_passant, {file, 6})
  end

  defp update_en_passant(game, _move) do
    Map.put(game, :en_passant, nil)
  end

  @spec update_halfmove_clock(Game.t(), Piece.t(), Piece.t() | nil) ::
          Game.t()
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

  @spec to_fen(Game.t()) :: String.t()
  def to_fen(%Game{} = game) do
    {:ok, fen} = Chex.Parser.FEN.serialize(game)
    fen
  end

  @spec move_valid?(Game.t(), {Square.t(), Square.t()}) ::
          boolean() | {:error, reason :: atom}
  defp move_valid?(%Game{} = game, {from, _to}) do
    with {:ok, _piece} <- piece_at(game, from), do: true
  end

  defp pickup_piece(game, square) do
    game.board
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
      game.board
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

  # defp switch_active_color

  @spec switch_active_color(Game.t()) :: Game.t()
  defp switch_active_color(%Game{active_color: :white} = game) do
    game |> Map.put(:active_color, :black)
  end

  defp switch_active_color(%Game{active_color: :black} = game) do
    game |> Map.put(:active_color, :white)
  end

  defp piece_at(game, square) do
    case Map.get(game.board, square) do
      nil ->
        {:error, :no_piece_at_square}

      piece ->
        {:ok, piece}
    end
  end

  @spec capture_piece(Game.t(), Piece.t() | nil) :: Game.t()
  defp capture_piece(game, nil), do: game

  defp capture_piece(%Game{captures: captures} = game, piece) do
    Map.put(game, :captures, [piece | captures])
  end
end
