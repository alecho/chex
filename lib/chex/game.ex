defmodule Chex.Game do
  defstruct board: Chex.Game.Board.new(),
            active_color: :white,
            castling: [:K, :Q, :k, :q],
            en_passant: nil,
            moves: [],
            halfmove_clock: 0,
            fullmove_clock: 0
end
