defmodule Chex.Game do
  @moduledoc false

  alias Chex.{Board, Color, Game, Move, Parser.FEN, Piece}

  defstruct board: %{},
            active_color: :white,
            castling: [:K, :Q, :k, :q],
            en_passant: nil,
            moves: [],
            halfmove_clock: 0,
            fullmove_clock: 1,
            captures: [],
            check: nil,
            result: nil,
            pgn: nil

  @doc """
  Creates a new game, optionally  from a FEN string.

  Returns a %Game{} initialized with fen or the default starting positions.

  ## Examples

  iex> Chex.Game.new()
  {:ok, %Chex.Game{}}
  iex> Chex.Game.new("rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
  {:ok, %Chex.Game{}}

  """
  @spec new :: {:ok, Chex.game()}
  def new do
    {:ok,
     %Game{
       board: Board.starting_position()
     }}
  end

  @spec new(String.t()) :: {:ok, Chex.game()} | {:error, atom()}
  def new(fen), do: FEN.parse(fen)

  @doc """
  Makes a move within the chess game.

  Returns a %Game{} modified by the move.

  ## Examples

  iex> {:ok, game} = Chex.Game.new()
  iex> Chex.Game.move(game, "e4e5")
  {error: :no_piece_at_square}
  iex> Chex.Game.move(game, "e2e4")
  {:ok, %Chex.Game{}}

  """
  @spec move(Chex.game(), Chex.move()) ::
          {:ok, Chex.game()} | {:error, atom()}
  def move(game, move) when is_binary(move) do
    move = Move.parse(move, game)
    move(game, move)
  end

  def move(game, {from, to, promote}), do: move(game, {from, to}, promote)

  def move(game, move), do: move(game, move, :queen)

  @spec move(Chex.game(), {Chex.square(), Chex.square()}, Chex.name()) ::
          {:ok, Chex.game()} | {:error, atom()}
  def move(game, {from, to} = move, promote_to) do
    with {:ok, _} <- validate_move(game, move),
         {:ok, {piece, capture, game}} <- Board.move(game, from, to),
         {:ok, game} <- castle(game, move) do
      piece = Piece.trim(piece)
      capture = if capture != nil, do: Piece.trim(capture)

      game =
        game
        |> add_move(move)
        |> capture_piece(capture)
        |> maybe_promote_pawn(promote_to)
        |> switch_active_color()
        |> update_check()
        |> update_castling(piece)
        |> update_en_passant(piece)
        |> update_halfmove_clock(piece, capture)
        |> maybe_increment_fullmove_clock(piece)
        |> maybe_update_result()

      {:ok, game}
    end
  end

  @doc """
  Makes a series of `moves` within the chess game.

  Returns a `{:ok, %Game{}` modified by the move or an error tuple.

  ## Examples

  iex> {:ok, game} = Chex.Game.new()
  iex> Chex.Game.move(game, "e4e5")
  {error: :no_piece_at_square}
  iex> Chex.Game.move(game, "e2e4")
  {:ok, %Chex.Game{}}

  """
  @spec moves(Chex.game(), [Chex.move()]) ::
          {:ok, Chex.game()} | {:error, atom()}
  def moves(game, moves) do
    Enum.reduce_while(moves, game, fn san, game ->
      case Chex.Move.parse(san, game) do
        {:error, _} = error ->
          {:halt, error}

        move ->
          {:ok, game} = move(game, move)
          {:cont, game}
      end
    end)
    |> case do
      {:error, _} = error -> error
      game -> {:ok, game}
    end
  end

  defdelegate in_check?(game, color), to: Game.Checking
  defdelegate checkmate?(game), to: Game.Checking
  defdelegate stalemate?(game), to: Game.Checking

  @spec result(Chex.game()) :: Chex.result()
  def result(game), do: game.result

  @spec add_move(Chex.game(), {Chex.square(), Chex.square()}) :: Chex.game()
  defp add_move(%Game{moves: moves} = game, move) do
    %{game | moves: [move | moves]}
  end

  @spec maybe_increment_fullmove_clock(Chex.game(), Chex.piece()) :: Chex.game()
  defp maybe_increment_fullmove_clock(game, {_name, :black}) do
    %{game | fullmove_clock: game.fullmove_clock + 1}
  end

  defp maybe_increment_fullmove_clock(game, _piece), do: game

  defp update_check(game) do
    check = if in_check?(game, game.active_color), do: game.active_color, else: nil
    %{game | check: check}
  end

  @spec update_castling(Chex.game(), Chex.piece()) :: Chex.game()
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

  @spec update_en_passant(Chex.game(), Chex.piece()) :: Chex.game()
  defp update_en_passant(
         %Game{moves: [{{file, 2}, {file, 4}} | _prev_moves]} = game,
         {:pawn, :white}
       ) do
    %{game | en_passant: {file, 3}}
  end

  defp update_en_passant(
         %Game{moves: [{{file, 7}, {file, 5}} | _prev_moves]} = game,
         {:pawn, :black}
       ) do
    %{game | en_passant: {file, 6}}
  end

  defp update_en_passant(%Game{en_passant: nil} = game, _move), do: game

  defp update_en_passant(game, _move), do: %{game | en_passant: nil}

  @spec update_halfmove_clock(Chex.game(), Chex.piece(), Chex.piece() | nil) :: Chex.game()
  defp update_halfmove_clock(game, {_, _}, {_, _}), do: %{game | halfmove_clock: 0}

  defp update_halfmove_clock(game, {:pawn, _color}, _), do: %{game | halfmove_clock: 0}

  defp update_halfmove_clock(game, _piece, _capture) do
    %{game | halfmove_clock: game.halfmove_clock + 1}
  end

  @spec validate_move(Chex.game(), Chex.move()) ::
          {:ok, Chex.game()} | {:error, reason :: atom}
  defp validate_move(%Game{} = game, {from, to}) do
    with {:ok, :noop} <-
           Board.occupied?(game, from)
           |> maybe_error(:no_piece_at_square),
         color <- Board.get_piece_color(game, from),
         {:ok, :noop} <-
           (game.active_color == color)
           |> maybe_error(:out_of_turn),
         {:ok, :noop} <-
           !Board.occupied_by_color?(game, color, to)
           |> maybe_error(:occupied_by_own_color),
         {:ok, :noop} <-
           (to in Piece.possible_moves(game, from))
           |> maybe_error(:invalid_move),
         do: {:ok, game}
  end

  # Queenside castle
  defp castle(game, {{:e, r}, {:c, r}}) when r in [1, 8] do
    {:ok,
     case Board.get_piece_name(game, {:c, r}) do
       :king -> castle_queenside(game, r)
       _ -> game
     end}
  end

  # Kingside castle
  defp castle(game, {{:e, r}, {:g, r}}) when r in [1, 8] do
    {:ok,
     case Board.get_piece_name(game, {:g, r}) do
       :king -> castle_kingside(game, r)
       _ -> game
     end}
  end

  defp castle(game, _move), do: {:ok, game}

  defp castle_kingside(game, rank) do
    {:ok, {_p, _c, game}} = Board.move(game, {:h, rank}, {:f, rank})
    game
  end

  defp castle_queenside(game, rank) do
    {:ok, {_p, _c, game}} = Board.move(game, {:a, rank}, {:d, rank})
    game
  end

  @spec switch_active_color(Chex.game()) :: Chex.game()
  defp switch_active_color(%{active_color: color} = game) do
    %{game | active_color: Color.flip(color)}
  end

  defp maybe_error(true, _reason), do: {:ok, :noop}
  defp maybe_error(false, reason), do: {:error, reason}

  @spec capture_piece(Chex.game(), Chex.piece() | nil) :: Chex.game()
  defp capture_piece(game, nil), do: game

  defp capture_piece(%Game{captures: captures} = game, piece) do
    %{game | captures: [piece | captures]}
  end

  @spec maybe_promote_pawn(Chex.game(), Chex.name()) :: Chex.game()
  defp maybe_promote_pawn(%{moves: [{_from, {_, d_rank} = sq} | _mvs]} = game, new_piece)
       when d_rank in [1, 8] do
    {_old, board} =
      game.board
      |> Map.get_and_update(sq, fn
        {:pawn, color, start} = cur -> {cur, {new_piece, color, start}}
        cur -> {cur, cur}
      end)

    %{game | board: board}
  end

  defp maybe_promote_pawn(game, _new_piece), do: game

  defp maybe_update_result(%{check: nil} = game) do
    case stalemate?(game) do
      true -> %{game | result: :draw}
      _ -> game
    end
  end

  defp maybe_update_result(%{check: color} = game) do
    case checkmate?(game) do
      true -> %{game | result: Color.flip(color)}
      _ -> game
    end
  end
end
