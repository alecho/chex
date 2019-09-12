defmodule Chex.Parser.FENTest do
  use ExUnit.Case
  doctest Chex.Parser.FEN

  @starting_pos "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
  @after_e4 "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1"
  # @after_c5 "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2"
  @after_Nf3 "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2"

  test "returns a Game struct" do
    assert %Chex.Game{} = Chex.Parser.FEN.parse(@starting_pos)
  end

  test "parses starting positions" do
    board = Chex.Parser.FEN.parse(@starting_pos) |> Map.get(:board)

    assert board == %{
             :__struct__ => Chex.Board,
             {:a, 1} => {:rook, :white},
             {:b, 1} => {:knight, :white},
             {:c, 1} => {:bishop, :white},
             {:d, 1} => {:queen, :white},
             {:e, 1} => {:king, :white},
             {:f, 1} => {:bishop, :white},
             {:g, 1} => {:knight, :white},
             {:h, 1} => {:rook, :white},
             {:a, 2} => {:pawn, :white},
             {:b, 2} => {:pawn, :white},
             {:c, 2} => {:pawn, :white},
             {:d, 2} => {:pawn, :white},
             {:e, 2} => {:pawn, :white},
             {:f, 2} => {:pawn, :white},
             {:g, 2} => {:pawn, :white},
             {:h, 2} => {:pawn, :white},
             {:a, 7} => {:pawn, :black},
             {:b, 7} => {:pawn, :black},
             {:c, 7} => {:pawn, :black},
             {:d, 7} => {:pawn, :black},
             {:e, 7} => {:pawn, :black},
             {:f, 7} => {:pawn, :black},
             {:g, 7} => {:pawn, :black},
             {:h, 7} => {:pawn, :black},
             {:a, 8} => {:rook, :black},
             {:b, 8} => {:knight, :black},
             {:c, 8} => {:bishop, :black},
             {:d, 8} => {:queen, :black},
             {:e, 8} => {:king, :black},
             {:f, 8} => {:bishop, :black},
             {:g, 8} => {:knight, :black},
             {:h, 8} => {:rook, :black}
           }
  end

  test "parses empty sqaure positions" do
    board = Chex.Parser.FEN.parse(@after_Nf3) |> Map.get(:board)

    assert board == %{
             :__struct__ => Chex.Board,
             {:a, 1} => {:rook, :white},
             {:b, 1} => {:knight, :white},
             {:c, 1} => {:bishop, :white},
             {:d, 1} => {:queen, :white},
             {:e, 1} => {:king, :white},
             {:f, 1} => {:bishop, :white},
             {:h, 1} => {:rook, :white},
             {:a, 2} => {:pawn, :white},
             {:b, 2} => {:pawn, :white},
             {:c, 2} => {:pawn, :white},
             {:d, 2} => {:pawn, :white},
             {:f, 2} => {:pawn, :white},
             {:g, 2} => {:pawn, :white},
             {:h, 2} => {:pawn, :white},
             {:f, 3} => {:knight, :white},
             {:e, 4} => {:pawn, :white},
             {:c, 5} => {:pawn, :black},
             {:a, 7} => {:pawn, :black},
             {:b, 7} => {:pawn, :black},
             {:d, 7} => {:pawn, :black},
             {:h, 7} => {:pawn, :black},
             {:e, 7} => {:pawn, :black},
             {:f, 7} => {:pawn, :black},
             {:g, 7} => {:pawn, :black},
             {:a, 8} => {:rook, :black},
             {:b, 8} => {:knight, :black},
             {:c, 8} => {:bishop, :black},
             {:d, 8} => {:queen, :black},
             {:e, 8} => {:king, :black},
             {:f, 8} => {:bishop, :black},
             {:g, 8} => {:knight, :black},
             {:h, 8} => {:rook, :black}
           }
  end

  test "parses white active" do
    assert %Chex.Game{
             active_color: :white
           } = Chex.Parser.FEN.parse(@starting_pos)
  end

  test "parses black active color" do
    assert %Chex.Game{
             active_color: :black
           } = Chex.Parser.FEN.parse(@after_e4)
  end

  test "parses present castling at starting position" do
    assert %Chex.Game{
             castling: [:K, :Q, :k, :q]
           } = Chex.Parser.FEN.parse(@starting_pos)
  end

  test "parses absent castling availability" do
    assert %Chex.Game{
             castling: []
           } = Chex.Parser.FEN.parse("r2k3r/8/8/8/8/8/8/R3K2R b - - 12 75")
  end

  test "parses absent en passant" do
    assert %Chex.Game{
             en_passant: nil
           } = Chex.Parser.FEN.parse(@starting_pos)
  end

  test "parses present en passant" do
    assert %Chex.Game{
             en_passant: {:e, 3}
           } = Chex.Parser.FEN.parse(@after_e4)
  end

  test "parses halfmove_clock" do
    assert %Chex.Game{
             halfmove_clock: 1
           } = Chex.Parser.FEN.parse(@after_Nf3)
  end

  test "parses fullmove_clock" do
    assert %Chex.Game{
             fullmove_clock: 2
           } = Chex.Parser.FEN.parse(@after_Nf3)
  end
end
