defmodule Chex.Parser.FENTest do
  use ExUnit.Case
  doctest Chex.Parser.FEN

  @starting_pos "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
  @after_e4 "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1"
  @after_c5 "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2"
  @after_Nf3 "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2"

  test "returns a Game struct" do
    assert %Chex.Game{} = Chex.Parser.FEN.parse(@starting_pos)
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
