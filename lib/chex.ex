defmodule Chex do
  @moduledoc """
  A library for playing chess in Elixir.
  """

  alias Chex.{Board, Color, Game, Piece}

  @typedoc """
  The main type representing a single game. Values should be treated as
  read-only and should only be modified using public API functions.

    * `:active_color` - The color of the player who's turn it is to move.
    * `:board` - The pieces on the board keyed by the square they occupy.
    * `:castling` - Castling rights.
    * `:en_passant` -  The _en passant_ square, if any.
    * `:moves` - A list of moves with the most recent move first.
    * `:halfmove_clock` -  Fifty-move rule. Set to 0 on pawn move or capture.
    * `:fullmove_clock` - Starts at 1 and is incremented after every black move.
    * `:captures` - A list of captured pieces. Most recent captures first.
    * `:check` - The color of the player in check.
    * `:result` - Set on game completion.
    * `:pgn` - A map with PGN tag pairs and `:moves` as values. `nil` if if not
    created from PGN data.

  """
  @type game :: %Game{
          active_color: color(),
          board: %{square() => Board.value()},
          castling: [castling_right()] | [],
          en_passant: square() | nil,
          moves: [move()] | [],
          halfmove_clock: non_neg_integer(),
          fullmove_clock: pos_integer(),
          captures: [piece()] | [],
          check: color() | nil,
          result: result(),
          pgn: map() | nil
        }

  @typedoc """
  A two element tuple with a file a-h as an atom and a rank integer 1-8.
  """
  @type square :: {file :: atom, rank :: pos_integer}

  @typedoc """
  A starting `t:square/0` and a destination `t:square/0` as a two element tuple
  or a three element tuple with a piece t:name() to promote to.
  """
  @type move ::
          {from :: square(), to :: square()}
          | {from :: square(), to :: square(), piece :: name()}

  @typedoc """
  One of `:white`, `:black`, `:draw`, or `nil`.
  """
  @type result :: color() | :draw | nil

  @typedoc """
  The color of a piece, square, or player as an atom.
  """
  @type color :: :white | :black

  @typedoc """
  The name of a piece as an atom.
  """
  @type name :: :king | :queen | :bishop | :knight | :rook | :pawn

  @typedoc """
  A `t:name/0`, `t:color/0` pair.
  """
  @type piece :: {name(), color()}

  @typedoc """
  A FEN style, single character, atom. Uppercase letters denote white's rights
  while lowercase letters denote black's.
  """
  @type castling_right :: :K | :Q | :k | :q

  @doc """
  Returns the other color.

  ## Examples

      iex> Chex.flip_color(:black)
      :white

      iex> Chex.flip_color(:white)
      :black

  """
  @spec flip_color(color()) :: color()
  defdelegate flip_color(color), to: Color, as: :flip

  @doc """
  Get the color of a piece at a square.

  ## Examples

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.get_piece_color(game, {:d, 1})
      :white

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.get_piece_color(game, {:d, 8})
      :black

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.get_piece_color(game, {:d, 5})
      nil
  """
  @spec get_piece_color(game(), square()) :: color() | nil
  defdelegate get_piece_color(game, square), to: Board

  @doc """
  Get the name of a piece at a square.

  ## Examples

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.get_piece_name(game, {:e, 1})
      :king

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.get_piece_name(game, {:e, 4})
      nil
  """
  @spec get_piece_name(game(), square()) :: name() | nil
  defdelegate get_piece_name(game, square), to: Board

  @doc """
  Makes a move on the provided `game`.

  If a piece name is not provided it promotes to queen.

  ## Examples

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.make_move(game, "e7e5")
      {:error, :out_of_turn}

      iex> {:ok, game} = Chex.new_game()
      iex> {:ok, game} = Chex.make_move(game, "e2e4")
      iex> Chex.make_move(game, "e2e3")
      {:error, :no_piece_at_square}

  """
  @spec make_move(game(), move()) :: {:ok, game()} | {:error, atom()}
  defdelegate make_move(game, move), to: Game, as: :move

  @doc """
  Creates a new game with the standard starting position.

  ## Examples

      iex> {:ok, game} = Chex.new_game()
      iex> game.active_color
      :white

  """
  @spec new_game :: {:ok, game()}
  defdelegate new_game, to: Game, as: :new

  @doc """
  Same as new_game/0 only returns a game or raises.

  ## Examples

  iex> Chex.new_game!().active_color
  :white

  """
  @spec new_game! :: game()
  def new_game! do
    case Game.new() do
      {:ok, game} -> game
    end
  end

  @doc """
  Check if a square is occupied by a piece.

  ## Examples

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.occupied?(game, {:b, 1})
      true

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.occupied?(game, {:a, 5})
      false

  """
  @spec occupied?(game(), square()) :: boolean
  defdelegate occupied?(game, square), to: Board

  @doc """
  Check if a square is occupied by a piece with the specified color.

  ## Examples

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.occupied_by_color?(game, :white, {:c, 1})
      true

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.occupied_by_color?(game, :black, {:c, 1})
      false

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.occupied_by_color?(game, :white, {:c, 5})
      false

  """
  @spec occupied_by_color?(game(), color(), square()) :: boolean
  defdelegate occupied_by_color?(game, color, square), to: Board

  @doc """
  Parse a FEN style piece string representation into a `t:String.t/0`.

  ## Examples

      iex> Chex.piece_from_string("N")
      {:knight, :white}

      iex> Chex.piece_from_string("q")
      {:queen, :black}

  """
  @spec piece_from_string(String.t()) :: piece()
  defdelegate piece_from_string(string), to: Piece, as: :from_string

  @doc """
  Returns a FEN style character from a given `t:String.t/0`.

  ## Examples

      iex> Chex.piece_to_string({:knight, :white})
      "N"

      iex> Chex.piece_to_string({:queen, :black})
      "q"

  """
  @spec piece_from_string(piece()) :: String.t()
  defdelegate piece_to_string(string), to: Piece, as: :to_string

  @doc """
  Get the possible moves for a piece at a given square.

  This function assumes the piece at the given square has the right to move.
  That is, it's the same color as the `:active_color` of the game state. This
  may not be true and the piece may not be able to move until the other color
  has made a move. This could cause the list of moves returned to be invalid.

  ## Examples

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.possible_moves(game, {:e, 2})
      [e: 4, e: 3]

      iex> {:ok, game} = Chex.new_game()
      iex> Chex.possible_moves(game, {:b, 8})
      [c: 6, a: 6]

  """
  @spec possible_moves(game(), square()) :: [square()] | []
  defdelegate possible_moves(game, square), to: Piece
end
