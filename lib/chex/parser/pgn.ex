defmodule Chex.Parser.PGN do
  @moduledoc """
  Portable Game Notation parser.
  """

  alias Chex.Move
  alias Chex.Parser

  @behaviour Parser

  import NimbleParsec

  any_tag_name = utf8_string([?0..?9, ?a..?z, ?A..?Z, ?_], min: 1)
  tag_value = utf8_string([not: ?\\, not: ?"], min: 1) |> label("tag value")

  tag_name =
    choice([
      string("Event") |> lookahead(ascii_char([?\s])) |> replace(:event),
      string("Site") |> lookahead(ascii_char([?\s])) |> replace(:site),
      string("Date") |> lookahead(ascii_char([?\s])) |> replace(:date),
      string("Round") |> lookahead(ascii_char([?\s])) |> replace(:round),
      string("White") |> lookahead(ascii_char([?\s])) |> replace(:white),
      string("Black") |> lookahead(ascii_char([?\s])) |> replace(:black),
      string("Result") |> lookahead(ascii_char([?\s])) |> replace(:result),
      string("ECO") |> lookahead(ascii_char([?\s])) |> replace(:eco),
      string("WhiteElo") |> lookahead(ascii_char([?\s])) |> replace(:white_elo),
      string("BlackElo") |> lookahead(ascii_char([?\s])) |> replace(:black_elo),
      string("PlyCount") |> lookahead(ascii_char([?\s])) |> replace(:ply_count),
      string("Annotator") |> lookahead(ascii_char([?\s])) |> replace(:annotator),
      string("TimeControl") |> lookahead(ascii_char([?\s])) |> replace(:time_control),
      string("Time") |> lookahead(ascii_char([?\s])) |> replace(:time),
      string("Termination") |> lookahead(ascii_char([?\s])) |> replace(:termination),
      string("Mode") |> lookahead(ascii_char([?\s])) |> replace(:mode),
      string("FEN") |> lookahead(ascii_char([?\s])) |> replace(:fen),
      string("SetUp") |> lookahead(ascii_char([?\s])) |> replace(:set_up),
      any_tag_name
    ])
    |> label("tag name")

  tag =
    ignore(eventually(ascii_char('[')))
    |> ignore(repeat(ascii_char([?\s])))
    |> concat(tag_name)
    |> ignore(repeat(ascii_char([?\s])))
    |> ignore(ascii_char('"'))
    |> concat(tag_value)
    |> ignore(string("\""))
    |> ignore(repeat(ascii_char([?\s])))
    |> ignore(string("]"))
    |> wrap

  move_num =
    integer(min: 1, max: 3)
    |> repeat(ascii_char('.'))
    |> repeat(ascii_char(' '))

  comment = string("{") |> eventually(string("}"))
  whitespace = ascii_char('\n\s\r')

  termination_marker =
    choice([
      string("1-0") |> replace(:white),
      string("0-1") |> replace(:black),
      string("1/2-1/2") |> replace(:draw),
      string("*") |> replace(nil)
    ])

  move_text = utf8_string([not: ?\n, not: ?\s, not: ?\r, not: ?\t], min: 2)

  move =
    ignore(repeat(whitespace))
    |> optional(ignore(move_num))
    |> concat(move_text)
    |> ignore(repeat(whitespace))
    |> optional(ignore(termination_marker))
    |> optional(ignore(comment))

  defparsec(:tag_pairs, tag |> times(min: 7) |> ignore(repeat(ascii_char('\r\n'))), inline: true)

  defparsec(
    :movetext,
    move
    |> optional(move)
    |> repeat()
    |> ignore(repeat(ascii_char('\r\n')))
    |> eos(),
    inline: true
  )

  defparsec(
    :result,
    eventually(termination_marker)
    |> ignore(repeat(whitespace)),
    inline: true
  )

  def parse(str) when is_binary(str) do
    with {:ok, tags, rem, _, _, _} <- tag_pairs(str),
         {:ok, moves, _rem, _, _, _} = rem |> movetext(),
         {:ok, [result], _rem, _, _, _} = rem |> result() do
      tags = tag_pairs_to_map(tags) |> Map.merge(%{moves: moves})
      game = %{Chex.new_game!() | pgn: tags, result: result}

      replay_moves(moves, game)
    end
  end

  defp replay_moves(moves, game) do
    Enum.reduce_while(moves, game, fn san, game ->
      case Move.parse(san, game) do
        {:error, _} = error ->
          {:halt, error}

        move ->
          {:ok, game} = Chex.make_move(game, move)
          {:cont, game}
      end
    end)
    |> case do
      {:error, _} = error -> error
      game -> {:ok, game}
    end
  end

  def serialize(_), do: {:ok, ""}
  def extension(), do: :pgn

  def tag_pairs_to_map(list) do
    list
    |> Enum.map(&List.to_tuple/1)
    |> Enum.into(%{})
  end

  def parse_movetext_section(str) do
    str
    |> movetext()
    |> Tuple.to_list()
    |> Enum.at(1)
  end
end
