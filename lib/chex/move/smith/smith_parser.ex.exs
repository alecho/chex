defmodule Chex.Move.SmithParser do
  @moduledoc false

  # parsec:Chex.Move.SmithParser
  import NimbleParsec

  @files ?a..?h
  @ranks ?1..?8
  @pieces 'rnbqk'

  file = utf8_char([@files]) |> label("file (a-h)")
  rank = utf8_char([@ranks]) |> label("rank (1-8)")
  square = concat(file, rank) |> label("square")
  move = concat(tag(square, :origin), tag(square, :destination))
  promotion = utf8_char(@pieces) |> label("lowercase piece identifier") |> tag(:promote)

  kingside_castle =
    choice([string("e1g1c"), string("e8g8c")]) |> replace(:kingside) |> unwrap_and_tag(:castle)

  queenside_castle =
    choice([string("e1c1c"), string("e8c8c")]) |> replace(:queenside) |> unwrap_and_tag(:castle)

  defparsec(
    :move,
    choice([lookahead_not(move, utf8_char([?c])), kingside_castle, queenside_castle])
    |> optional(promotion),
    inline: true
  )

  # parsec:Chex.Move.SmithParser
end
