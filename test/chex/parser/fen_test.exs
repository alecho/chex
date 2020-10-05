defmodule Chex.Parser.FENTest do
  use ExUnit.Case
  doctest Chex.Parser.FEN

  @starting_pos "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
  @after_e4 "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1"
  # @after_c5 "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2"
  @after_nf3 "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2"

  test "returns a Game struct" do
    assert {:ok, %Chex.Game{}} = Chex.Parser.FEN.parse(@starting_pos)
  end

  test "parses starting positions" do
    {:ok, game} = Chex.Parser.FEN.parse(@starting_pos)

    assert game.board == %{
             :__struct__ => Chex.Board,
             {:c, 2} => {:pawn, :white, {:c, 2}},
             {:g, 1} => {:knight, :white, {:g, 1}},
             {:a, 8} => {:rook, :black, {:a, 8}},
             {:h, 7} => {:pawn, :black, {:h, 7}},
             {:c, 1} => {:bishop, :white, {:c, 1}},
             {:d, 1} => {:queen, :white, {:d, 1}},
             {:d, 7} => {:pawn, :black, {:d, 7}},
             {:g, 7} => {:pawn, :black, {:g, 7}},
             {:c, 8} => {:bishop, :black, {:c, 8}},
             {:b, 8} => {:knight, :black, {:b, 8}},
             {:a, 7} => {:pawn, :black, {:a, 7}},
             {:e, 1} => {:king, :white, {:e, 1}},
             {:h, 8} => {:rook, :black, {:h, 8}},
             {:e, 8} => {:king, :black, {:e, 8}},
             {:f, 7} => {:pawn, :black, {:f, 7}},
             {:b, 2} => {:pawn, :white, {:b, 2}},
             {:g, 2} => {:pawn, :white, {:g, 2}},
             {:h, 2} => {:pawn, :white, {:h, 2}},
             {:e, 7} => {:pawn, :black, {:e, 7}},
             {:f, 2} => {:pawn, :white, {:f, 2}},
             {:a, 2} => {:pawn, :white, {:a, 2}},
             {:g, 8} => {:knight, :black, {:g, 8}},
             {:f, 8} => {:bishop, :black, {:f, 8}},
             {:b, 1} => {:knight, :white, {:b, 1}},
             {:d, 2} => {:pawn, :white, {:d, 2}},
             {:b, 7} => {:pawn, :black, {:b, 7}},
             {:a, 1} => {:rook, :white, {:a, 1}},
             {:f, 1} => {:bishop, :white, {:f, 1}},
             {:d, 8} => {:queen, :black, {:d, 8}},
             {:h, 1} => {:rook, :white, {:h, 1}},
             {:c, 7} => {:pawn, :black, {:c, 7}},
             {:e, 2} => {:pawn, :white, {:e, 2}}
           }
  end

  test "parses empty sqaure positions" do
    {:ok, game} = Chex.Parser.FEN.parse(@after_nf3)

    assert game.board == %{
             :__struct__ => Chex.Board,
             {:c, 2} => {:pawn, :white, {:c, 2}},
             {:f, 1} => {:bishop, :white, {:f, 1}},
             {:c, 5} => {:pawn, :black, {:c, 5}},
             {:h, 7} => {:pawn, :black, {:h, 7}},
             {:f, 7} => {:pawn, :black, {:f, 7}},
             {:c, 1} => {:bishop, :white, {:c, 1}},
             {:g, 7} => {:pawn, :black, {:g, 7}},
             {:c, 8} => {:bishop, :black, {:c, 8}},
             {:b, 8} => {:knight, :black, {:b, 8}},
             {:f, 2} => {:pawn, :white, {:f, 2}},
             {:d, 7} => {:pawn, :black, {:d, 7}},
             {:a, 7} => {:pawn, :black, {:a, 7}},
             {:e, 1} => {:king, :white, {:e, 1}},
             {:h, 8} => {:rook, :black, {:h, 8}},
             {:f, 8} => {:bishop, :black, {:f, 8}},
             {:f, 3} => {:knight, :white, {:f, 3}},
             {:e, 8} => {:king, :black, {:e, 8}},
             {:b, 2} => {:pawn, :white, {:b, 2}},
             {:g, 2} => {:pawn, :white, {:g, 2}},
             {:a, 1} => {:rook, :white, {:a, 1}},
             {:h, 2} => {:pawn, :white, {:h, 2}},
             {:d, 8} => {:queen, :black, {:d, 8}},
             {:e, 7} => {:pawn, :black, {:e, 7}},
             {:a, 8} => {:rook, :black, {:a, 8}},
             {:g, 8} => {:knight, :black, {:g, 8}},
             {:d, 1} => {:queen, :white, {:d, 1}},
             {:b, 1} => {:knight, :white, {:b, 1}},
             {:a, 2} => {:pawn, :white, {:a, 2}},
             {:b, 7} => {:pawn, :black, {:b, 7}},
             {:e, 4} => {:pawn, :white, {:e, 4}},
             {:d, 2} => {:pawn, :white, {:d, 2}},
             {:h, 1} => {:rook, :white, {:h, 1}}
           }
  end

  test "parses white active" do
    assert {:ok,
            %Chex.Game{
              active_color: :white
            }} = Chex.Parser.FEN.parse(@starting_pos)
  end

  test "parses black active color" do
    assert {:ok,
            %Chex.Game{
              active_color: :black
            }} = Chex.Parser.FEN.parse(@after_e4)
  end

  test "parses present castling at starting position" do
    assert {:ok,
            %Chex.Game{
              castling: [:K, :Q, :k, :q]
            }} = Chex.Parser.FEN.parse(@starting_pos)
  end

  test "parses absent castling availability" do
    assert {:ok,
            %Chex.Game{
              castling: []
            }} = Chex.Parser.FEN.parse("r2k3r/8/8/8/8/8/8/R3K2R b - - 12 75")
  end

  test "parses absent en passant" do
    assert {:ok,
            %Chex.Game{
              en_passant: nil
            }} = Chex.Parser.FEN.parse(@starting_pos)
  end

  test "parses present en passant" do
    assert {:ok,
            %Chex.Game{
              en_passant: {:e, 3}
            }} = Chex.Parser.FEN.parse(@after_e4)
  end

  test "parses halfmove_clock" do
    assert {:ok,
            %Chex.Game{
              halfmove_clock: 1
            }} = Chex.Parser.FEN.parse(@after_nf3)
  end

  test "parses fullmove_clock" do
    assert {:ok,
            %Chex.Game{
              fullmove_clock: 2
            }} = Chex.Parser.FEN.parse(@after_nf3)
  end

  test "parses newgame" do
    {:ok, game} = Chex.Game.new()
    assert Chex.Parser.FEN.serialize(game) == {:ok, @starting_pos}
  end

  test "parses after first move" do
    {:ok, game} = Chex.Game.new(@after_e4)
    assert Chex.Parser.FEN.serialize(game) == {:ok, @after_e4}
  end
end
