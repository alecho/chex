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
            fullmove_clock: 0

  @type t() :: %__MODULE__{}

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
  end

  @spec move(Chex.Game.t(), Chex.Square.t(), Chex.Square.t()) :: Chex.Game.t()
  def move(game, from, to) do
    {piece, board} =
      game
      |> Map.get(:board)
      |> Map.get_and_update(from, fn current ->
        {current, nil}
      end)

    {_piece, board} =
      board
      |> Map.get_and_update(to, fn current ->
        {current, piece}
      end)

    game
    |> Map.put(:board, board)
  end

  # defp move_valid?(game, from, to)
  # defp prepend_move(game, from, to)
  # defp move_piece(game, from, to)
  # defp maybe_add_piece_to_captures
  # defp update_fen
  # defp switch_active_color
end
