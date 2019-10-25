defmodule Chex.SquareTest do
  use ExUnit.Case
  import AssertValue
  doctest Chex.Square

  test "correctly determines color" do
    squares = for f <- [:a, :b, :c, :d, :e, :f, :g, :h], r <- 1..8, do: {f, r}

    results =
      squares
      |> Enum.map(fn sq ->
        {sq, Chex.Square.color(sq)}
      end)

    assert results == [
             {{:a, 1}, :dark},
             {{:a, 2}, :light},
             {{:a, 3}, :dark},
             {{:a, 4}, :light},
             {{:a, 5}, :dark},
             {{:a, 6}, :light},
             {{:a, 7}, :dark},
             {{:a, 8}, :light},
             {{:b, 1}, :light},
             {{:b, 2}, :dark},
             {{:b, 3}, :light},
             {{:b, 4}, :dark},
             {{:b, 5}, :light},
             {{:b, 6}, :dark},
             {{:b, 7}, :light},
             {{:b, 8}, :dark},
             {{:c, 1}, :dark},
             {{:c, 2}, :light},
             {{:c, 3}, :dark},
             {{:c, 4}, :light},
             {{:c, 5}, :dark},
             {{:c, 6}, :light},
             {{:c, 7}, :dark},
             {{:c, 8}, :light},
             {{:d, 1}, :light},
             {{:d, 2}, :dark},
             {{:d, 3}, :light},
             {{:d, 4}, :dark},
             {{:d, 5}, :light},
             {{:d, 6}, :dark},
             {{:d, 7}, :light},
             {{:d, 8}, :dark},
             {{:e, 1}, :dark},
             {{:e, 2}, :light},
             {{:e, 3}, :dark},
             {{:e, 4}, :light},
             {{:e, 5}, :dark},
             {{:e, 6}, :light},
             {{:e, 7}, :dark},
             {{:e, 8}, :light},
             {{:f, 1}, :light},
             {{:f, 2}, :dark},
             {{:f, 3}, :light},
             {{:f, 4}, :dark},
             {{:f, 5}, :light},
             {{:f, 6}, :dark},
             {{:f, 7}, :light},
             {{:f, 8}, :dark},
             {{:g, 1}, :dark},
             {{:g, 2}, :light},
             {{:g, 3}, :dark},
             {{:g, 4}, :light},
             {{:g, 5}, :dark},
             {{:g, 6}, :light},
             {{:g, 7}, :dark},
             {{:g, 8}, :light},
             {{:h, 1}, :light},
             {{:h, 2}, :dark},
             {{:h, 3}, :light},
             {{:h, 4}, :dark},
             {{:h, 5}, :light},
             {{:h, 6}, :dark},
             {{:h, 7}, :light},
             {{:h, 8}, :dark}
           ]
  end

  test "valid?" do
    bad_squares = [nil: 2, i: 1, a: -1, A: 1, h: 9, b: 0]
    good_squares = for f <- [:a, :b, :c, :d, :e, :f, :g, :h], r <- 1..8, do: {f, r}
    squares = good_squares ++ bad_squares

    results = Enum.map(squares, &Chex.Square.valid?(&1))

    assert_value(
      results == [
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        false,
        false,
        false,
        false,
        false,
        false
      ]
    )
  end
end
