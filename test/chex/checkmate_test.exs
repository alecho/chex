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
  end
end
