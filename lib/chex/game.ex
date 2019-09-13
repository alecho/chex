defmodule Chex.Game do
  defstruct board: Chex.Board.new(),
            active_color: :white,
            castling: [:K, :Q, :k, :q],
            en_passant: nil,
            moves: [],
            halfmove_clock: 0,
            fullmove_clock: 0

  @starting_pos "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

  def new(fen \\ @starting_pos) do
    Chex.Parser.FEN.parse(fen)
  end
end
