defmodule Chex.CheckmateTest do
  use ExUnit.Case, async: true

  alias Chex.Game

  describe "king and queen" do
    test "support mate" do
      {:ok, game} = Game.new("8/k1K5/8/8/8/8/8/1Q6 w - - 0 1")
      {:ok, game} = Game.move(game, "b1b7")
      assert Game.in_check?(game, :black) == true
      assert Game.result(game) == :white
    end

    test "right triangle mate" do
      {:ok, game} = Game.new("8/8/5K1k/8/8/8/8/6Q1 w - - 0 1")
      {:ok, game} = Game.move(game, "g1h1")
      assert Game.result(game) == :white
    end

    test "cornered mate" do
      {:ok, game} = Game.new("8/8/8/8/8/6K1/4Q3/7k w - - 0 1")
      {:ok, game} = Game.move(game, "e2e1")
      assert Game.result(game) == :white
    end
  end

  describe "common checkmates" do
    test "back-rank mate" do
      {:ok, game} = Game.new("6k1/3R1ppp/8/8/8/8/8/4K3 w - - 0 1")
      {:ok, game} = Game.move(game, "d7d8")
      assert Game.result(game) == :white
    end

    test "scholar's mate" do
      {:ok, game} =
        Game.new("r1bqkb1r/pppp1ppp/2n2n2/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR w KQkq - 0 1")

      {:ok, game} = Game.move(game, "h5f7")

      assert Game.result(game) == :white
    end

    test "fool's mate" do
      {:ok, game} = Game.new("rnbqkbnr/pppp1ppp/8/4p3/6P1/5P2/PPPPP2P/RNBQKBNR b KQkq - 0 1")
      {:ok, game} = Game.move(game, "d8h4")

      assert Game.result(game) == :black
    end
  end
end
