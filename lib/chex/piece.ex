defmodule Chex.Piece do
  @moduledoc """
  Piece behaviour and piece functions.
  """
  alias Chex.{Board, Game, Piece, Square}

  @typedoc """
  A name atom.
  """
  @type name :: :king | :queen | :bishop | :knight | :rook | :pawn

  @typedoc """
  A name(), Color.() pair.
  """
  @type t :: {name(), Color.t()}

  @callback possible_moves(Color.t(), Square.t(), Game.t()) :: [Square.t()]
  @callback attacking_squares(Color.t(), Square.t(), en_passant :: Square.t()) :: [Square.t()]

  @spec possible_moves(Game.t(), Square.t()) :: [Square.t()]
  def possible_moves(game, square) do
    {name, color, _id} = game.board[square]

    to_module(name).possible_moves(color, square, game)
    |> Enum.reject(&Board.occupied_by_color?(game, color, &1))
    |> Enum.reject(fn sq ->
      {:ok, {_piece, _capture, psudo_game}} = Board.move(game, square, sq)
      Game.in_check?(psudo_game, color)
    end)
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
  @spec trim({name(), Color.t(), Square.t()}) :: Piece.t()
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

  def to_string({name, color, _id}), do: Piece.to_string({name, color})

  def to_string({name, color}) do
    %{
      king: "k",
      queen: "q",
      bishop: "b",
      knight: "n",
      rook: "r",
      pawn: "p"
    }[name]
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
