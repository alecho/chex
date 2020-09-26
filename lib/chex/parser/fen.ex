defmodule Chex.Parser.FEN do
  @moduledoc """
  Forsyth–Edwards Notation parser.
  """

  @behaviour Chex.Parser

  # import Map, only: [put: 3]
  import Enum, only: [at: 2]
  import String, only: [split: 1, split: 2, split: 3]

  def parse(fen) when is_binary(fen) do
    fen_parts = fen |> fen_to_map

    {:ok,
     %Chex.Game{
       board: decode_board(fen_parts |> at(0)),
       active_color: decode_active_color(fen_parts |> at(1)),
       castling: decode_castling(fen_parts |> at(2)),
       en_passant: decode_en_passant(fen_parts |> at(3)),
       halfmove_clock: decode_halfmove_clock(fen_parts |> at(4)),
       fullmove_clock: decode_fullmove_clock(fen_parts |> at(5))
     }}
  end

  def serialize(%Chex.Game{} = game) do
    bd = serialize_board(game.board)
    ac = serialize_active_color(game.active_color)
    ct = serialize_castling(game.castling)
    ep = serialize_en_passant(game.en_passant)
    hm = game.halfmove_clock
    fm = game.fullmove_clock

    {:ok, "#{bd} #{ac} #{ct} #{ep} #{hm} #{fm}"}
  end

  def extension(), do: nil

  defp fen_to_map(fen) do
    split(fen)
  end

  @spec decode_board(String.t()) :: %Chex.Board{}
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
    |> Enum.reduce(%Chex.Board{}, fn {square, piece}, board ->
      Map.put(board, square, Tuple.append(piece, square))
    end)
  end

  @spec serialize_board(%Chex.Board{}) :: String.t()
  def serialize_board(board) do
    8..1
    |> Enum.map(fn r ->
      Chex.Board.files()
      |> Enum.map(fn f ->
        board |> Map.get({f, r})
      end)
    end)
    |> Enum.map(fn rank ->
      rank
      |> Enum.chunk_by(&is_nil(&1))
      |> Enum.map(fn chunk ->
        chunk
        |> Enum.at(0)
        |> case do
          nil ->
            Enum.count(chunk)
            |> Integer.to_string()

          _ ->
            chunk
            |> Enum.map(&Chex.Piece.to_string(&1))
        end
      end)
    end)
    |> Enum.join("/")
  end

  def decode_rank(chars, pieces, _file_index, _rank) when chars == [], do: pieces

  def decode_rank(chars, pieces, file_index, rank) do
    {char, chars} = chars |> List.pop_at(0)

    case Integer.parse(char) do
      :error ->
        file = at(Chex.Board.files(), file_index)

        pieces = [
          {{file, rank}, Chex.Piece.from_string(char)}
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

  @spec decode_en_passant(String.t()) :: Chex.Square.t()
  def decode_en_passant("-"), do: nil

  def decode_en_passant(san) when byte_size(san) == 2 do
    [file | [rank]] = san |> split("", trim: true)
    decode_en_passant(file, rank)
  end

  @spec decode_en_passant(String.t(), String.t()) :: Chex.Square.t()
  def decode_en_passant(file, rank)
      when file in ["a", "b", "c", "d", "e", "f", "g", "h"] and
             rank in ["1", "2", "3", "4", "5", "6", "7", "8"] do
    {String.to_existing_atom(file), String.to_integer(rank)}
  end

  @spec serialize_en_passant(Chex.Square.t()) :: String.t()
  def serialize_en_passant(nil), do: "-"

  def serialize_en_passant({file, rank}) do
    "#{file}#{rank}"
  end

  def decode_halfmove_clock(string), do: String.to_integer(string)
  def decode_fullmove_clock(string), do: String.to_integer(string)
end
