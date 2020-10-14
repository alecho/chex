defmodule Chex.CheckTest do
  use ExUnit.Case, async: true

  alias Chex.Game

  describe "in_check?/2" do
    test "not in check is false" do
      {:ok, game} = Game.new()
      assert Game.in_check?(game, :black) == false
    end

    test "in check is true" do
      {:ok, game} = Game.new("4k3/8/8/8/4R3/8/8/4K3 w - - 0 1")
      assert Game.in_check?(game, :black) == true
    end

    test "in mate is true" do
      {:ok, game} = Game.new("4k2Q/R7/8/8/8/8/8/4K3 w - - 0 1")
      assert Game.in_check?(game, :black) == true
    end
  end
end
