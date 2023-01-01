defmodule Chex.Square do
  @moduledoc false

  require Integer

  def color({file, rank}) when file in [:a, :c, :e, :g] and Integer.is_even(rank), do: :light

  def color({file, rank}) when file in [:a, :c, :e, :g] and Integer.is_odd(rank), do: :dark

  def color({file, rank}) when file in [:b, :d, :f, :h] and Integer.is_even(rank), do: :dark

  def color({file, rank}) when file in [:b, :d, :f, :h] and Integer.is_odd(rank), do: :light

  def from_string(str) when is_binary(str) do
    [fs, rs] = String.codepoints(str)
    {String.to_existing_atom(fs), String.to_integer(rs)}
  end

  def from_charlist([file, rank] = list) when is_list(list) do
    {file_to_atom(file), rank - 48}
  end

  defp file_to_atom(file) when is_integer(file) do
    List.to_existing_atom([file])
  end

  def valid?({f, r}) do
    Enum.member?(Chex.Board.files(), f) && Enum.member?(1..8, r)
  end

  @doc """

  ## Examples

      iex> Chex.Square.from_reverse_rtl_index(0)
      {:a, 8}

      iex> Chex.Square.from_reverse_rtl_index(1)
      {:b, 8}

      iex> Chex.Square.from_reverse_rtl_index(2)
      {:c, 8}

      iex> Chex.Square.from_reverse_rtl_index(7)
      {:h, 8}

      iex> Chex.Square.from_reverse_rtl_index(56)
      {:a, 1}

      iex> Chex.Square.from_reverse_rtl_index(63)
      {:h, 1}

  """
  def from_reverse_rtl_index(i) do
    fi = Integer.floor_div(i, 8)
    file = Enum.at(Chex.Board.files(), Integer.mod(i, 8))
    {file, abs(fi - 8)}
  end
end
