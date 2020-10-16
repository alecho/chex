defmodule Chex.StalemateTest do
  use ExUnit.Case, async: true

  alias Chex.Game

  describe "only king remains" do
    test "king and pawm stalemate" do
      {:ok, game} = Game.new("4k3/4P3/8/4K3/8/8/8/8 w - - 0 1")
      {:ok, game} = Game.move(game, "e5e6")

      assert Game.result(game) == :draw
    end

    test "king and rook stalemate" do
      {:ok, game} = Game.new("8/1R6/8/8/8/2K5/8/k7 w - - 0 1")
      {:ok, game} = Game.move(game, "b7b2")

      assert Game.result(game) == :draw
    end

    test "wrong bishop stalemate" do
      {:ok, game} = Game.new("1k6/P7/K7/6B1/8/8/8/8 w - - 0 1")
      {:ok, game} = Game.move(game, "g5f4")
      assert Game.in_check?(game, :black) == true

      {:ok, game} = Game.move(game, "b8a8")
      assert Game.result(game) == nil

      {:ok, game} = Game.move(game, "f4e5")
      assert Game.result(game) == :draw
    end
  end

  describe "more than king remains" do
    test "pinned bishop stalemate" do
      {:ok, game} = Game.new("kb6/8/1K6/8/8/8/8/7R w - - 0 1")
      {:ok, game} = Game.move(game, "h1h8")

      assert Game.result(game) == :draw
    end

    test "queen vs pawn endgame" do
      {:ok, game} = Game.new("8/8/8/6K1/8/1Q6/p7/k7 w - - 0 1")
      {:ok, game} = Game.move(game, "g5f5")

      assert Game.result(game) == :draw
    end
  end
end
