defmodule Chex.Move.SAN do
  alias Chex.{Piece, Square}

  import Chex.Move.SanParser, only: [move: 1]

  @files ?a..?h
  @file_atoms [:a, :b, :c, :d, :e, :f, :g, :h]
  @ranks ?1..?8
  @rank_ints 1..8
  @piece_atoms [:rook, :knight, :bishop, :queen, :king]

  @default_map %{
    destination: nil,
    origin: nil,
    piece: :pawn,
    capture: false,
    check: false,
    checkmate: false,
    en_passant: false,
    castle: nil,
    promote: nil
  }

  @doc """
  """
  def to_map(san) when is_binary(san) do
    case move(san) do
      {:ok, list, _, _, _, _} ->
        map = Map.merge(@default_map, Enum.into(list, %{}))

        %{
          map
          | piece: parse_piece(map.piece),
            destination: parse_square(map.destination),
            origin: parse_square(map.origin),
            promote: parse_piece(map.promote)
        }

      {:error, reason, _, _, _, _} ->
        raise ArgumentError, message: "Unknown move: #{san}, #{reason}"
    end
  end

  defp parse_piece(list) when is_list(list) do
    list
    |> to_string()
    |> Piece.from_string()
    |> Tuple.to_list()
    |> List.first()
  end

  defp parse_piece(piece), do: piece

  def parse_square(list) when length(list) == 2, do: Square.from_charlist(list)
  def parse_square([char]) when char in @ranks, do: char - 48
  def parse_square([char]) when char in @files, do: List.to_existing_atom([char])
  def parse_square(_), do: nil

  @doc """
  get a t:Chex.move() from a SAN string.

  ## Examples

      # Pawn moves
      iex> Chex.Move.SAN.parse("e4", Chex.new_game!())
      {{:e, 2}, {:e, 4}}

      # Invalid move. White is the first to move.
      iex> Chex.Move.SAN.parse("e5", Chex.new_game!())
      {:error, :invalid_move}

      # Non pawn moves
      iex> Chex.Move.SAN.parse("Nf3", Chex.new_game!())
      {{:g, 1}, {:f, 3}}

  """
  @spec parse(san :: String.t(), Chex.game()) :: Chex.move() | {:error, any()}
  def parse(san, game) do
    san
    |> to_map()
    |> to_move(game)
    |> maybe_error()
  end

  def to_move(%{castle: :kingside}, %{active_color: :white}), do: {{:e, 1}, {:g, 1}}
  def to_move(%{castle: :kingside}, %{active_color: :black}), do: {{:e, 8}, {:g, 8}}

  def to_move(%{castle: :queenside}, %{active_color: :white}), do: {{:e, 1}, {:c, 1}}
  def to_move(%{castle: :queenside}, %{active_color: :black}), do: {{:e, 8}, {:c, 8}}

  def to_move(%{destination: to, origin: nil} = san_map, game) do
    from = find_origin(game, {san_map.piece, game.active_color}, to)
    move_tuple(from, to, san_map.promote)
  end

  def to_move(%{destination: to, origin: from} = san_map, game) do
    from = find_origin(game, {san_map.piece, game.active_color}, to, from)
    move_tuple(from, to, san_map.promote)
  end

  @spec find_origin(Chex.game(), Chex.piece(), Chex.square()) :: Chex.square() | nil
  defp find_origin(game, piece, dest) do
    Chex.Board.find_pieces(game, piece)
    |> Enum.find(fn sq -> dest in Chex.Piece.possible_moves(game, sq) end)
  end

  defp find_origin(game, piece, dest, from_file) when from_file in @files do
    from_file = List.to_existing_atom([from_file])
    find_origin(game, piece, dest, from_file)
  end

  defp find_origin(game, piece, dest, from_rank) when from_rank in @ranks do
    from_rank = from_rank - 48
    find_origin(game, piece, dest, from_rank)
  end

  defp find_origin(game, piece, dest, {ff, fr}) when fr in @ranks do
    fr = fr - 48
    find_origin(game, piece, dest, {ff, fr})
  end

  defp find_origin(game, piece, dest, {ff, fr}) when ff in @files do
    ff = List.to_existing_atom([ff])
    find_origin(game, piece, dest, {ff, fr})
  end

  defp find_origin(game, piece, dest, from_file) when from_file in @file_atoms do
    Chex.Board.find_pieces(game, piece)
    |> Enum.filter(fn sq -> dest in Chex.Piece.possible_moves(game, sq) end)
    |> Enum.filter(fn {f, _} -> f == from_file end)
    |> List.first()
  end

  defp find_origin(game, piece, dest, from_rank) when from_rank in @rank_ints do
    Chex.Board.find_pieces(game, piece)
    |> Enum.filter(fn sq -> dest in Chex.Piece.possible_moves(game, sq) end)
    |> Enum.filter(fn {_, r} -> r == from_rank end)
    |> List.first()
  end

  defp find_origin(game, piece, dest, {ff, fr}) when fr in @rank_ints do
    Chex.Board.find_pieces(game, piece)
    |> Enum.filter(fn sq -> dest in Chex.Piece.possible_moves(game, sq) end)
    |> Enum.filter(fn
      {^ff, ^fr} -> true
      _ -> false
    end)
    |> List.first()
  end

  defp move_tuple(from, to, nil), do: {from, to}
  defp move_tuple(from, to, promote), do: {from, to, promote}

  defp maybe_error({{tf, tr}, {ff, fr}} = move)
       when tf in @file_atoms and ff in @file_atoms and
              tr in @rank_ints and fr in @rank_ints,
       do: move

  defp maybe_error({{tf, tr}, {ff, fr}, piece} = move)
       when tf in @file_atoms and ff in @file_atoms and
              tr in @rank_ints and fr in @rank_ints and
              piece in @piece_atoms,
       do: move

  defp maybe_error(_move), do: {:error, :invalid_move}
end
