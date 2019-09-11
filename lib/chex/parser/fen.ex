defmodule Chex.Parser.FEN do
  @moduledoc """
  Forsyth–Edwards Notation parser.
  """

  # import Map, only: [put: 3]
  import Enum, only: [at: 2]
  import String, only: [split: 1, split: 3]

  def parse(fen) when is_binary(fen) do
    fen_parts = fen |> fen_to_map

    %Chex.Game{
      active_color: decode_active_color(fen_parts |> at(1)),
      castling: decode_castling(fen_parts |> at(2)),
      en_passant: decode_en_passant(fen_parts |> at(3)),
      halfmove_clock: decode_halfmove_clock(fen_parts |> at(4)),
      fullmove_clock: decode_fullmove_clock(fen_parts |> at(5))
    }
  end

  defp fen_to_map(fen) do
    split(fen)
  end

  def decode_active_color("w"), do: :white

  def decode_active_color("b"), do: :black

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

  def decode_en_passant("-"), do: nil

  def decode_en_passant(san) when byte_size(san) == 2 do
    [file | [rank]] = san |> split("", trim: true)
    decode_en_passant(file, rank)
  end

  def decode_en_passant(file, rank)
      when file in ["a", "b", "c", "d", "e", "f", "g", "h"] and
             rank in ["1", "2", "3", "4", "5", "6", "7", "8"] do
    {String.to_existing_atom(file), String.to_integer(rank)}
  end

  def decode_halfmove_clock(string), do: String.to_integer(string)
  def decode_fullmove_clock(string), do: String.to_integer(string)
end
