defmodule Chex.Square do
  require Integer

  @typedoc """
  File a-h as an atom, with an file integer 1-8.
  """
  @type t :: {file :: atom, rank :: pos_integer}

  def color({file, rank}) when file in [:a, :c, :e, :g] and Integer.is_even(rank), do: :light

  def color({file, rank}) when file in [:a, :c, :e, :g] and Integer.is_odd(rank), do: :dark

  def color({file, rank}) when file in [:b, :d, :f, :h] and Integer.is_even(rank), do: :dark

  def color({file, rank}) when file in [:b, :d, :f, :h] and Integer.is_odd(rank), do: :light
end
