defmodule Chex.Move.SanParser do
  @moduledoc false

  # parsec:Chex.Move.SanParser
  import NimbleParsec

  @files ?a..?h
  @ranks ?1..?8
  @pieces 'RNBQK'

  piece = ascii_char(@pieces) |> label("piece identifier")
  file = ascii_char([@files]) |> label("file (a-h)")
  rank = ascii_char([@ranks]) |> label("rank (1-8)")
  square = concat(file, rank) |> label("square")
  kingside_castle = string("O-O") |> lookahead_not(string("-O")) |> replace(:kingside)
  queenside_castle = string("O-O-O") |> replace(:queenside)

  capture =
    ascii_char('x')
    |> label("capture indicator (x)")
    |> replace(true)
    |> unwrap_and_tag(:capture)

  check =
    ascii_char('+')
    |> label("check indicator (+)")
    |> replace(true)
    |> unwrap_and_tag(:check)

  checkmate =
    ascii_char('#')
    |> label("checkmate indicator")
    |> replace(true)
    |> unwrap_and_tag(:checkmate)

  en_passant =
    string("e.p.")
    |> label("En passant indicator (e.p.)")
    |> replace(true)
    |> unwrap_and_tag(:en_passant)

  promotion =
    ignore(string("=")) |> label("promotion indicator (=)") |> concat(piece) |> tag(:promote)

  pawn_move =
    optional(
      choice([file, rank])
      |> tag(:origin)
      |> lookahead(choice([capture, square]))
    )
    |> optional(capture)
    |> concat(square |> tag(:destination))
    |> optional(choice([promotion, en_passant]))
    |> optional(choice([check, checkmate]))

  piece_move =
    tag(piece, :piece)
    |> optional(
      choice([square, file, rank])
      |> tag(:origin)
      |> lookahead(choice([capture, square]))
    )
    |> optional(capture)
    |> concat(square |> tag(:destination))
    |> optional(choice([check, checkmate]))

  castle = choice([kingside_castle, queenside_castle]) |> unwrap_and_tag(:castle)

  defparsec(:move, choice([pawn_move, piece_move, castle]), inline: true)

  # parsec:Chex.Move.SanParser
end
