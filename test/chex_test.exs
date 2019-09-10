defmodule ChexTest do
  use ExUnit.Case
  doctest Chex

  test "creates a new game GenServer" do
    assert {:ok, pid} = Chex.new_game()
    assert is_pid(pid)
  end
end
