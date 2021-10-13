defimpl Inspect, for: Chex.Game do
  @unicode_map %{
    {:white, :pawn} => "♙",
    {:white, :rook} => "♖",
    {:white, :knight} => "♘",
    {:white, :bishop} => "♗",
    {:white, :queen} => "♕",
    {:white, :king} => "♔",
    {:black, :pawn} => "♟",
    {:black, :rook} => "♜",
    {:black, :knight} => "♞",
    {:black, :bishop} => "♝",
    {:black, :queen} => "♛",
    {:black, :king} => "♚",
    nil => " "
  }

  @ranks 8..1
  @files [:a, :b, :c, :d, :e, :f, :g, :h]

  @doc """
  Output a string in the unicode notation shown below.

  iex> Chex.Game.new
    8 [♜][♞][♝][♛][♚][♝][♞][♜]
    7 [♟][♟][♟][♟][♟][♟][♟][♟]
    6 [ ][ ][ ][ ][ ][ ][ ][ ]
    5 [ ][ ][ ][ ][ ][ ][ ][ ]
    4 [ ][ ][ ][ ][ ][ ][ ][ ]
    3 [ ][ ][ ][ ][ ][ ][ ][ ]
    2 [♙][♙][♙][♙][♙][♙][♙][♙]
    1 [♖][♘][♗][♕][♔][♗][♘][♖]
       a  b  c  d  e  f  g  h
  """
  def inspect(game, opts) do
    for rank <- @ranks, file <- @files do
      piece =
        case Map.get(game.board, {file, rank}) do
          {material, color, _} -> {color, material}
          _ -> nil
        end

      unicode = Map.get(@unicode_map, piece)
      "[#{unicode}]"
    end
    |> Enum.chunk_every(8)
    |> Enum.with_index()
    |> Enum.map(fn {row, rank} -> ["#{8 - rank} " | row] |> Enum.join("") end)
    |> Enum.concat(["   a  b  c  d  e  f  g  h"])
    |> Enum.join("\n")
  end
end
