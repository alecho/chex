defmodule Chex.Color do
  @moduledoc """

  """

  @typedoc """
  A color atom.
  """
  @type t :: :white | :black

  def flip(:white), do: :black
  def flip(:black), do: :white
end
