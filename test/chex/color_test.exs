defmodule Chex.ColorTest do
  use ExUnit.Case, async: true
  doctest Chex.Board

  alias Chex.Color

  describe "Color.flip/1" do
    test "when given :white return :black" do
      assert Color.flip(:white) == :black
    end

    test "when given :black return :white" do
      assert Color.flip(:black) == :white
    end
  end
end
