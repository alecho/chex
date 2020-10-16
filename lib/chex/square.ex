defmodule Chex.Square do
  @moduledoc false

  require Integer

  @typedoc """
  File a-h as an atom, with an file integer 1-8.
  """
  @type t :: {file :: atom, rank :: pos_integer}

  def color({file, rank}) when file in [:a, :c, :e, :g] and Integer.is_even(rank), do: :light

  def color({file, rank}) when file in [:a, :c, :e, :g] and Integer.is_odd(rank), do: :dark

  def color({file, rank}) when file in [:b, :d, :f, :h] and Integer.is_even(rank), do: :dark

  def color({file, rank}) when file in [:b, :d, :f, :h] and Integer.is_odd(rank), do: :light

  def from_string(str) when is_binary(str) do
    [fs, rs] = String.codepoints(str)
    {String.to_existing_atom(fs), String.to_integer(rs)}
  end

  def valid?({f, r}) do
    Enum.member?(Chex.Board.files(), f) && Enum.member?(1..8, r)
  end
end
