defmodule Chex.Color do
  @moduledoc false

  @spec flip(color :: Chex.color()) :: Chex.color()
  def flip(:white), do: :black
  def flip(:black), do: :white
end
