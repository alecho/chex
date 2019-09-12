defmodule Chex.Piece do
  @typedoc """
  A name, color atom pair.
  """
  @type t :: {name :: atom, color :: atom}

  @spec from_string(String.t()) :: Chex.Piece.t()
  def from_string(str) do
    {piece_from_string(str), color_from_string(str)}
  end

  @spec piece_from_string(String.t()) :: atom
  defp piece_from_string(str) when byte_size(str) == 1 do
    %{
      "k" => :king,
      "q" => :queen,
      "b" => :bishop,
      "n" => :knight,
      "r" => :rook,
      "p" => :pawn
    }
    |> Map.get(String.downcase(str, :ascii))
  end

  @spec color_from_string(String.t()) :: atom
  defp color_from_string(str) when byte_size(str) == 1 do
    str_up =
      str
      |> String.upcase(:ascii)

    case str == str_up do
      true ->
        :white

      false ->
        :black
    end
  end
end
