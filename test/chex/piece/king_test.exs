defmodule Chex.Piece.KingTest do
  use ExUnit.Case, async: true
  doctest Chex.Piece.King

  test "all moves valid" do
    {:ok, game} = Chex.Game.new("4k3/8/8/8/3K4/8/8/8 w - - 0 1")

    moves = Chex.Piece.possible_moves(game, {:d, 4})

    expected_moves = [
      {:c, 5},
      {:d, 5},
      {:e, 5},
      {:c, 4},
      {:e, 4},
      {:c, 3},
      {:d, 3},
      {:e, 3}
    ]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "king in corner" do
    {:ok, game} = Chex.Game.new("4k3/8/8/8/8/8/8/K7 w - - 0 1")
    moves = Chex.Piece.possible_moves(game, {:a, 1})

    expected_moves = [
      {:a, 2},
      {:b, 2},
      {:b, 1}
    ]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "king surrounded by pawns" do
    {:ok, game} = Chex.Game.new("4k3/8/8/2PPP3/2PKP3/2PPP3/8/8 w - - 0 1")
    moves = Chex.Piece.possible_moves(game, {:d, 4})

    assert moves == []
  end

  test "king blocked diagonally" do
    {:ok, game} = Chex.Game.new("4k3/8/8/2P1P3/3K4/2P1P3/8/8 w - - 0 1")
    moves = Chex.Piece.possible_moves(game, {:d, 4})

    expected_moves = [
      {:d, 5},
      {:c, 4},
      {:e, 4},
      {:d, 3}
    ]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "king must capture to move" do
    {:ok, game} = Chex.Game.new("4k3/8/8/2PPP3/2PKP3/2ppp3/8/8 w - - 0 1")
    moves = Chex.Piece.possible_moves(game, {:d, 4})

    expected_moves = [
      {:c, 3},
      {:d, 3},
      {:e, 3}
    ]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "king blocked by king" do
    {:ok, game} = Chex.Game.new("8/8/3k4/8/3K4/8/8/8 w - - 0 1")
    moves = Chex.Piece.possible_moves(game, {:d, 4})

    expected_moves = [
      {:c, 4},
      {:e, 4},
      {:c, 3},
      {:d, 3},
      {:e, 3}
    ]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "king blocked by pawn" do
    {:ok, game} = Chex.Game.new("4k3/8/3p4/8/3K4/8/8/8 w - - 0 1")
    moves = Chex.Piece.possible_moves(game, {:d, 4})

    expected_moves = [
      {:d, 5},
      {:c, 4},
      {:e, 4},
      {:c, 3},
      {:d, 3},
      {:e, 3}
    ]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "king blocked by pawn with backup" do
    {:ok, game} = Chex.Game.new("4k3/8/2p5/3p4/3K4/8/8/8 w - - 0 1")
    moves = Chex.Piece.possible_moves(game, {:d, 4})

    expected_moves = [
      {:c, 5},
      {:e, 5},
      {:c, 3},
      {:d, 3},
      {:e, 3}
    ]

    assert Enum.sort(moves) == Enum.sort(expected_moves)
  end

  test "mate by pawns" do
    {:ok, game} = Chex.Game.new("4k3/8/2pp4/3pp3/1ppKpp2/8/8/8 w - - 0 1")
    moves = Chex.Piece.possible_moves(game, {:d, 4})

    assert moves == []
  end

  describe "castling" do
    test "white king can castle" do
      {:ok, game} = Chex.Game.new("r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1")
      moves = Chex.Piece.possible_moves(game, {:e, 1})

      assert {:g, 1} in moves
      assert {:c, 1} in moves
    end

    test "black king can castle" do
      {:ok, game} = Chex.Game.new("r3k2r/8/8/8/8/8/8/R3K2R b KQkq - 0 1")
      moves = Chex.Piece.possible_moves(game, {:e, 8})

      assert {:g, 8} in moves
      assert {:c, 8} in moves
    end

    test "white cannot castle when blocked by own piece" do
      {:ok, game} = Chex.Game.new("r3k2r/8/8/8/8/8/8/R1N1KB1R w KQkq - 0 1")
      moves = Chex.Piece.possible_moves(game, {:e, 1})

      refute {:g, 1} in moves
      refute {:c, 1} in moves
    end

    test "black cannot castle when blocked by own piece" do
      {:ok, game} = Chex.Game.new("r1n1kb1r/8/8/8/8/8/8/R1N1KB1R b KQkq - 0 1")
      moves = Chex.Piece.possible_moves(game, {:e, 8})

      refute {:g, 8} in moves
      refute {:c, 8} in moves
    end

    test "white cannot castle when blocked by enemy piece" do
      {:ok, game} = Chex.Game.new("r3k2r/8/8/8/8/8/8/R1n1Kb1R w KQkq - 0 1")
      moves = Chex.Piece.possible_moves(game, {:e, 1})

      refute {:g, 1} in moves
      refute {:c, 1} in moves
    end

    test "black cannot castle when blocked by enemy piece" do
      {:ok, game} = Chex.Game.new("r1N1kB1r/8/8/8/8/8/8/R1N1KB1R b KQkq - 0 1")
      moves = Chex.Piece.possible_moves(game, {:e, 8})

      refute {:g, 8} in moves
      refute {:c, 8} in moves
    end

    test "cannot castle when in check" do
      {:ok, game} = Chex.Game.new("r3k2r/8/8/1Q6/8/8/8/4K3 b kq - 0 1")
      game = %{game | check: :black}
      moves = Chex.Piece.possible_moves(game, {:e, 8})

      refute {:g, 8} in moves
      refute {:c, 8} in moves
    end

    test "can castle when rook is attacked" do
      {:ok, game} = Chex.Game.new("4k3/6q1/8/8/8/8/8/R3K2R w KQ - 0 1")
      moves = Chex.Piece.possible_moves(game, {:e, 1})

      assert {:c, 1} in moves
    end

    test "cannot castle into check" do
      {:ok, game} = Chex.Game.new("4k3/6q1/8/8/8/8/8/R3K2R w KQ - 0 1")
      moves = Chex.Piece.possible_moves(game, {:e, 1})

      refute {:g, 1} in moves
    end

    test "cannot castle through attacked squares" do
      {:ok, game} = Chex.Game.new("4k3/8/8/8/6q1/8/8/R3K2R b KQ - 0 1")
      moves = Chex.Piece.possible_moves(game, {:e, 1})

      refute {:g, 1} in moves
      refute {:c, 1} in moves
    end

    test "cannot queenside castle when rook is blocked by own piece" do
      {:ok, game} = Chex.Game.new("r3k2r/8/8/8/8/8/8/RN2K2R b KQkq - 0 1")
      moves = Chex.Piece.possible_moves(game, {:e, 1})

      refute {:c, 1} in moves
    end

    test "cannot queenside castle when rook is blocked by enemy piece" do
      {:ok, game} = Chex.Game.new("r3k2r/8/8/8/8/8/8/Rn2K2R b KQkq - 0 1")
      moves = Chex.Piece.possible_moves(game, {:e, 1})

      refute {:c, 1} in moves
    end

    test "attacking b file does not prevent queenside castling" do
      # Averbakh vs. Purdy, 1960
      {:ok, game} = Chex.Game.new("r3kb1r/p5pp/2p1bp2/4p3/2P5/2P5/P2NPP1P/1RB1K2R w Kkq - 0 1")
      moves = Chex.Piece.possible_moves(game, {:e, 8})

      assert {:c, 8} in moves
    end
  end
end
