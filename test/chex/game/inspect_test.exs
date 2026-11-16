defmodule Chex.Game.InspectTest do
  use ExUnit.Case, async: true

  describe "inspect game" do
    test "new game" do
      expected =
        """
        8 [♜][♞][♝][♛][♚][♝][♞][♜]
        7 [♟][♟][♟][♟][♟][♟][♟][♟]
        6 [ ][ ][ ][ ][ ][ ][ ][ ]
        5 [ ][ ][ ][ ][ ][ ][ ][ ]
        4 [ ][ ][ ][ ][ ][ ][ ][ ]
        3 [ ][ ][ ][ ][ ][ ][ ][ ]
        2 [♙][♙][♙][♙][♙][♙][♙][♙]
        1 [♖][♘][♗][♕][♔][♗][♘][♖]
           a  b  c  d  e  f  g  h
        """
        |> String.trim()

      assert expected == inspect(Chex.new_game!())
    end

    test "promotion game" do
      expected =
        """
        8 [ ][ ][ ][ ][ ][ ][ ][ ]
        7 [ ][ ][♚][ ][♙][ ][ ][ ]
        6 [ ][ ][ ][ ][ ][ ][ ][ ]
        5 [ ][ ][ ][ ][ ][ ][ ][ ]
        4 [ ][ ][ ][ ][ ][ ][ ][ ]
        3 [ ][ ][ ][ ][ ][ ][ ][ ]
        2 [ ][ ][♔][ ][ ][ ][ ][ ]
        1 [ ][ ][ ][ ][ ][ ][ ][ ]
           a  b  c  d  e  f  g  h
        """
        |> String.trim()

      {:ok, game} = Chex.Game.new("8/2k1P3/8/8/8/8/2K5/8 w - - 0 1")

      IO.inspect(game)

      assert expected == inspect(game)
    end
  end
end
