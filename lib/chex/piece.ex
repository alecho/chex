defmodule Chex.Piece do
  @moduledoc """
  Piece behaviour and piece functions.
  """
  alias Chex.{Game, Piece, Square}

  @typedoc """
  A name atom.
  """
  @type name :: :king | :queen | :bishop | :knight | :rook | :pawn

  @typedoc """
  A color atom.
  """
  @type color :: :white | :black

  @typedoc """
  A name(), color() pair.
  """
  @type t :: {name(), color()}

  @callback possible_moves(color(), Square.t(), Game.t()) :: [Square.t()]
  @callback attacking_squares(color(), Square.t(), en_passant :: Square.t()) :: [Square.t()]

  @spec possible_moves(t(), Square.t(), Game.t()) :: [Square.t()]
  def possible_moves({name, color}, square, game) do
    module = to_module(name)
    module.possible_moves(color, square, game)
  end

  @spec attacking_squares(t(), Square.t(), Game.t()) :: [Square.t()]
  def attacking_squares({name, color}, square, game) do
    module = to_module(name)
    module.attacking_squares(color, square, game)
  end

  @spec from_string(String.t()) :: Piece.t()
  def from_string(str) do
    {piece_from_string(str), color_from_string(str)}
  end

  @doc """
  Removes the trailing starting square from a three element tuple.

  Returns a Piece.t(). This is useful as the piece data stored in the
  game.board contains the piece's starting square as a means of identification.

  ## Examples

  iex> Chex.Piece.trim({:pawn, :white, {:e, 2}})
  {:pawn, :white}

  """
  @spec trim({name(), color(), Square.t()}) :: Piece.t()
  def trim({name, color, _start}), do: {name, color}

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

    if str == str_up, do: :white, else: :black
  end

  def to_string({name, color, _id}), do: Chex.Piece.to_string({name, color})

  def to_string({name, color}) do
    %{
      king: "k",
      queen: "q",
      bishop: "b",
      knight: "n",
      rook: "r",
      pawn: "p"
    }
    |> Map.get(name)
    |> case_for_color(color)
  end

  @spec to_module(name :: name()) :: module()
  def to_module(name) do
    name =
      name
      |> Kernel.to_string()
      |> String.capitalize()

    String.to_atom("Elixir.Chex.Piece." <> name)
  end

  @spec case_for_color(String.t(), atom) :: String.t()
  def case_for_color(char, :white), do: String.upcase(char)
  def case_for_color(char, _black), do: char
end
