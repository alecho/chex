defmodule Chex.Parser.FEN do
  @moduledoc """
  Forsyth–Edwards Notation parser.
  """

  alias Chex.{Board, Game, Parser, Piece, Square}

  @behaviour Parser

  # import Map, only: [put: 3]
  import Enum, only: [at: 2]
  import String, only: [split: 1, split: 2, split: 3]

  def parse(fen) when is_binary(fen) do
    [bd, ac, ct, ep, hm, fm] = split(fen)

    {:ok,
     %Game{
       board: decode_board(bd),
       active_color: decode_active_color(ac),
       castling: decode_castling(ct),
       en_passant: decode_en_passant(ep),
       halfmove_clock: decode_halfmove_clock(hm),
       fullmove_clock: decode_fullmove_clock(fm)
     }}
  end

  def serialize(%Game{
        board: bd,
        active_color: ac,
        castling: ct,
        en_passant: ep,
        halfmove_clock: hm,
        fullmove_clock: fm
      }) do
    bd = serialize_board(bd)
    ac = serialize_active_color(ac)
    ct = serialize_castling(ct)
    ep = serialize_en_passant(ep)

    {:ok, "#{bd} #{ac} #{ct} #{ep} #{hm} #{fm}"}
  end

  def extension, do: nil

  @spec decode_board(String.t()) :: %{}
  def decode_board(str) do
    str
    |> split("/")
    |> Enum.with_index()
    |> Enum.map(fn {rank_string, i} ->
      rank_string
      |> String.codepoints()
      |> decode_rank([], 0, 8 - i)
    end)
    |> List.flatten()
    |> Enum.reduce(%{}, fn {square, piece}, board ->
      Map.put(board, square, Tuple.append(piece, square))
    end)
  end

  @spec serialize_board(%{}) :: String.t()
  def serialize_board(board) do
    for r <- 8..1, f <- Board.files() do
      Map.get(board, {f, r})
    end
    |> Enum.chunk_every(8)
    |> Enum.map(fn row ->
      row
      |> Enum.reduce({"", 0}, &row_to_string(&1, &2))
      |> row_to_string()
    end)
    |> Enum.join("/")
  end

  defp row_to_string({row, 0}), do: row
  defp row_to_string({row, count}), do: "#{row}#{count}"

  defp row_to_string(nil, {_acc, 7}), do: {"8", 0}
  defp row_to_string(nil, {acc, count}), do: {acc, count + 1}
  defp row_to_string(piece, {acc, 0}), do: {acc <> Piece.to_string(piece), 0}
  defp row_to_string(piece, {acc, count}), do: row_to_string(piece, {"#{acc}#{count}", 0})

  def decode_rank(chars, pieces, _file_index, _rank) when chars == [], do: pieces

  def decode_rank(chars, pieces, file_index, rank) do
    {char, chars} = chars |> List.pop_at(0)

    case Integer.parse(char) do
      :error ->
        file = at(Board.files(), file_index)

        pieces = [
          {{file, rank}, Piece.from_string(char)}
          | pieces
        ]

        decode_rank(chars, pieces, file_index + 1, rank)

      {n, _rem} ->
        decode_rank(chars, pieces, file_index + n, rank)
    end
  end

  @spec decode_active_color(String.t()) :: atom
  def decode_active_color("w"), do: :white

  def decode_active_color("b"), do: :black

  @spec serialize_active_color(atom) :: String.t()
  def serialize_active_color(:white), do: "w"

  def serialize_active_color(:black), do: "b"

  @spec decode_castling(String.t()) :: [String.t()]
  def decode_castling("-"), do: []

  def decode_castling(string) do
    string
    |> split("", trim: true)
    |> Enum.filter(fn piece -> piece in ["K", "Q", "k", "q"] end)
    |> Enum.reduce([], fn piece, list ->
      [String.to_existing_atom(piece) | list]
    end)
    |> Enum.sort()
  end

  @spec serialize_castling(list) :: String.t()
  def serialize_castling([]), do: "-"

  def serialize_castling(list) do
    list
    |> Enum.join()
  end

  @spec decode_en_passant(String.t()) :: Square.t()
  def decode_en_passant("-"), do: nil

  def decode_en_passant(san) when byte_size(san) == 2 do
    [file | [rank]] = san |> split("", trim: true)
    decode_en_passant(file, rank)
  end

  @spec decode_en_passant(String.t(), String.t()) :: Square.t()
  def decode_en_passant(file, rank)
      when file in ["a", "b", "c", "d", "e", "f", "g", "h"] and
             rank in ["1", "2", "3", "4", "5", "6", "7", "8"] do
    {String.to_existing_atom(file), String.to_integer(rank)}
  end

  @spec serialize_en_passant(Square.t()) :: String.t()
  def serialize_en_passant(nil), do: "-"

  def serialize_en_passant({file, rank}) do
    "#{file}#{rank}"
  end

  def decode_halfmove_clock(string), do: String.to_integer(string)
  def decode_fullmove_clock(string), do: String.to_integer(string)
end
