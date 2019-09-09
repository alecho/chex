defmodule ChexTest do
  use ExUnit.Case
  doctest Chex

  test "greets the world" do
    assert Chex.hello() == :world
  end
end
