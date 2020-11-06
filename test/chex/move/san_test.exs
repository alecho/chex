defmodule Chex.Move.SANTest do
  use ExUnit.Case, async: true
  doctest Chex.Move.SAN

  alias Chex.Move.SAN

  describe "pawn moves" do
    test "basic pawn move" do
      assert {{:a, 2}, {:a, 3}} = SAN.parse("a3", Chex.new_game!())
    end

    test "first pawn move" do
      assert {{:b, 2}, {:b, 4}} = SAN.parse("b4", Chex.new_game!())
    end

    test "promotion" do
      {:ok, game} = Chex.Game.new("8/2k1P3/8/8/8/8/2K5/8 w - - 0 1")
      assert {{:e, 7}, {:e, 8}, :queen} = SAN.parse("e8=Q", game)
    end

    test "capture" do
      {:ok, game} = Chex.Game.new("rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1")

      assert {{:e, 4}, {:d, 5}} = SAN.parse("exd5", game)
    end

    @tag :skip
    test "en passant capture" do
      {:ok, game} = Chex.Game.new("rnbqkbnr/ppp1p1pp/8/3pPp2/8/8/PPPP1PPP/RNBQKBNR w KQkq f6 0 2")

      assert {{:e, 5}, {:f, 6}} = SAN.parse("exf6e.p.", game)
    end

    test "promotion with capture" do
      {:ok, game} = Chex.Game.new("5r2/2k1P3/8/8/8/8/2K5/8 w - - 0 1")
      assert {{:e, 7}, {:f, 8}, :queen} = SAN.parse("exf8=Q", game)
    end

    test "promotion with check" do
      {:ok, game} = Chex.Game.new("2k5/4P3/8/8/8/8/2K5/8 w - - 0 1")
      assert {{:e, 7}, {:e, 8}, :queen} = SAN.parse("e8=Q+", game)
    end

    test "promotion with capture and check" do
      {:ok, game} = Chex.Game.new("2k2r2/4P3/8/8/8/8/2K5/8 w - - 0 1")
      assert {{:e, 7}, {:f, 8}, :queen} = SAN.parse("exf8=Q+", game)
    end

    test "underpromotion with capture and check" do
      {:ok, game} = Chex.Game.new("2k2r2/4P3/8/8/8/8/2K5/8 w - - 0 1")
      assert {{:e, 7}, {:f, 8}, :rook} = SAN.parse("exf8=R+", game)
    end
  end

  describe "non-pawn moves" do
    test "rook" do
      {:ok, game} = Chex.Game.new("r3k3/8/8/8/8/8/8/4K2R w - - 0 1")
      assert {{:h, 1}, {:h, 5}} = SAN.parse("Rh5", game)
      assert {{:a, 8}, {:d, 8}} = SAN.parse("Rd8", %{game | active_color: :black})
    end

    test "rook with check" do
      {:ok, game} = Chex.Game.new("r3k3/8/8/8/8/8/8/4K2R w - - 0 1")
      assert {{:h, 1}, {:h, 8}} = SAN.parse("Rh8+", game)
      assert {{:a, 8}, {:a, 1}} = SAN.parse("Ra1+", %{game | active_color: :black})
    end

    test "knight" do
      {:ok, game} = Chex.Game.new()
      assert {{:g, 1}, {:f, 3}} = SAN.parse("Nf3", game)
    end

    test "knight with check" do
      {:ok, game} = Chex.Game.new("4k3/8/8/3Nn3/8/8/8/4K3 w - - 0 1")
      assert {{:d, 5}, {:c, 7}} = SAN.parse("Nc7+", game)
      assert {{:e, 5}, {:f, 3}} = SAN.parse("Nf3+", %{game | active_color: :black})
    end

    test "bishop" do
      {:ok, game} = Chex.Game.new("2b1k3/8/8/8/8/8/8/2B1K3 w - - 0 1")
      assert {{:c, 1}, {:g, 5}} = SAN.parse("Bg5", game)
      assert {{:c, 8}, {:g, 4}} = SAN.parse("Bg4", %{game | active_color: :black})
    end

    test "queen" do
      {:ok, game} = Chex.Game.new("3qk3/8/8/8/8/8/8/3QK3 w - - 0 1")
      assert {{:d, 1}, {:a, 4}} = SAN.parse("Qa4", game)
    end

    test "king" do
      {:ok, game} = Chex.Game.new("4k3/8/8/8/8/8/8/4K3 w - - 0 1")
      assert {{:e, 1}, {:d, 2}} = SAN.parse("Kd2", game)
    end
  end

  describe "castling" do
    setup _ do
      {:ok, game} =
        Chex.Game.new("r2qk2r/ppp2ppp/2nbbn2/3pp3/3PP3/2NBBN2/PPP2PPP/R2QK2R w KQkq - 4 6")

      [game: game]
    end

    test "white kingside", %{game: game} do
      assert {{:e, 1}, {:g, 1}} = SAN.parse("O-O", game)
    end

    test "white queenside", %{game: game} do
      assert {{:e, 1}, {:c, 1}} = SAN.parse("O-O-O", game)
    end

    test "black kingside", %{game: game} do
      assert {{:e, 8}, {:g, 8}} = SAN.parse("O-O", %{game | active_color: :black})
    end

    test "black queenside", %{game: game} do
      assert {{:e, 8}, {:c, 8}} = SAN.parse("O-O-O", %{game | active_color: :black})
    end
  end

  describe "ambiguous moves" do
    setup _ do
      {:ok, game} = Chex.Game.new("2kr3r/b7/3b4/R7/4Q2Q/8/6K1/R6Q w - - 0 1")
      [game: game]
    end

    test "bishop differentiated by file", %{game: game} do
      game = %{game | active_color: :black}
      assert {{:d, 6}, {:b, 8}} = SAN.parse("Bdb8", game)
      assert {{:a, 7}, {:b, 8}} = SAN.parse("Bab8", game)
    end

    test "rook differentiated by file", %{game: game} do
      game = %{game | active_color: :black}
      assert {{:d, 8}, {:f, 8}} = SAN.parse("Rdf8", game)
      assert {{:h, 8}, {:f, 8}} = SAN.parse("Rhf8", game)
    end

    test "differentiated by rank", %{game: game} do
      assert {{:a, 1}, {:a, 3}} = SAN.parse("R1a3", game)
      assert {{:a, 5}, {:a, 3}} = SAN.parse("R5a3", game)
    end

    test "differentiated by file and rank", %{game: game} do
      assert {{:h, 4}, {:e, 1}} = SAN.parse("Qh4e1", game)
    end
  end
end
