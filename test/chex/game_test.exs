defmodule Chex.GameTest do
  use ExUnit.Case, async: true
  import AssertValue

  alias Chex.Game

  describe "new/0" do
    test "returns new game state" do
      {:ok, game} = Game.new()

      assert_value(
        game == %Game{
          active_color: :white,
          board: %{
            :__struct__ => Chex.Board,
            {:a, 1} => {:rook, :white, {:a, 1}},
            {:a, 2} => {:pawn, :white, {:a, 2}},
            {:a, 7} => {:pawn, :black, {:a, 7}},
            {:a, 8} => {:rook, :black, {:a, 8}},
            {:b, 1} => {:knight, :white, {:b, 1}},
            {:b, 2} => {:pawn, :white, {:b, 2}},
            {:b, 7} => {:pawn, :black, {:b, 7}},
            {:b, 8} => {:knight, :black, {:b, 8}},
            {:c, 1} => {:bishop, :white, {:c, 1}},
            {:c, 2} => {:pawn, :white, {:c, 2}},
            {:c, 7} => {:pawn, :black, {:c, 7}},
            {:c, 8} => {:bishop, :black, {:c, 8}},
            {:d, 1} => {:queen, :white, {:d, 1}},
            {:d, 2} => {:pawn, :white, {:d, 2}},
            {:d, 7} => {:pawn, :black, {:d, 7}},
            {:d, 8} => {:queen, :black, {:d, 8}},
            {:e, 1} => {:king, :white, {:e, 1}},
            {:e, 2} => {:pawn, :white, {:e, 2}},
            {:e, 7} => {:pawn, :black, {:e, 7}},
            {:e, 8} => {:king, :black, {:e, 8}},
            {:f, 1} => {:bishop, :white, {:f, 1}},
            {:f, 2} => {:pawn, :white, {:f, 2}},
            {:f, 7} => {:pawn, :black, {:f, 7}},
            {:f, 8} => {:bishop, :black, {:f, 8}},
            {:g, 1} => {:knight, :white, {:g, 1}},
            {:g, 2} => {:pawn, :white, {:g, 2}},
            {:g, 7} => {:pawn, :black, {:g, 7}},
            {:g, 8} => {:knight, :black, {:g, 8}},
            {:h, 1} => {:rook, :white, {:h, 1}},
            {:h, 2} => {:pawn, :white, {:h, 2}},
            {:h, 7} => {:pawn, :black, {:h, 7}},
            {:h, 8} => {:rook, :black, {:h, 8}}
          },
          captures: [],
          castling: [:K, :Q, :k, :q],
          en_passant: nil,
          fullmove_clock: 1,
          halfmove_clock: 0,
          moves: []
        }
      )
    end
  end

  describe "move/2" do
    test "returns {:ok, game} when move is valid" do
      {:ok, game} = Game.new()
      assert {:ok, game} = Game.move(game, "e2e4")
    end

    test "returns {:error, :no_piece_at_square} when starting square is empty" do
      {:ok, game} = Game.new()
      assert {:error, :no_piece_at_square} = Game.move(game, "e4e5")
    end

    test "returns {:error, :out_of_turn} when piece is not the active color" do
      {:ok, game} = Game.new()
      {:ok, game} = Game.move(game, "e2e4")
      assert {:error, :out_of_turn} = Game.move(game, "e4e5")
    end

    test "returns {:error, :occupied_by_own_color} when blocked at destination" do
      {:ok, game} = Game.new()
      assert {:error, :occupied_by_own_color} = Game.move(game, "g1e2")
    end

    test "appends the move to :moves" do
      {:ok, game} = Game.new()
      {:ok, game} = Game.move(game, "e2e4")
      assert game.moves == [{{:e, 2}, {:e, 4}}]
    end

    test "moves the piece on the :board" do
      {:ok, game} = Game.new()
      {:ok, game} = Game.move(game, "e2e4")
      assert game.board |> Map.get({:e, 2}) == nil
      assert game.board |> Map.get({:e, 4}) == {:pawn, :white, {:e, 2}}
    end

    test "updates :en_passant" do
      {:ok, game} = Game.new()
      {:ok, game} = Game.move(game, "e2e4")
      assert game.en_passant == {:e, 3}
    end

    test "resets :en_passant" do
      {:ok, game} = Game.new()
      {:ok, game} = Game.move(game, "e2e4")
      {:ok, game} = Game.move(game, "g8f6")
      assert game.en_passant == nil
    end

    test "updates :halfmove_clock" do
      {:ok, game} = Game.new()
      {:ok, game} = Game.move(game, "g1f3")
      assert game.halfmove_clock == 1
      {:ok, game} = Game.move(game, "g8f6")
      assert game.halfmove_clock == 2
      {:ok, game} = Game.move(game, "b1c3")
      assert game.halfmove_clock == 3
      {:ok, game} = Game.move(game, "b8c6")
      assert game.halfmove_clock == 4
    end

    test "resets :halfmove_clock on pawn move" do
      {:ok, game} = Game.new()
      {:ok, game} = Game.move(game, "g1f3")
      {:ok, game} = Game.move(game, "g8f6")
      assert game.halfmove_clock == 2
      {:ok, game} = Game.move(game, "e2e4")
      assert game.halfmove_clock == 0
    end

    test "resets :halfmove_clock on capture" do
      {:ok, game} = Game.new()
      {:ok, game} = Game.move(game, "g1f3")
      {:ok, game} = Game.move(game, "b8c6")
      {:ok, game} = Game.move(game, "f3d4")
      assert game.halfmove_clock == 3
      {:ok, game} = Game.move(game, "c6d4")
      assert game.halfmove_clock == 0
    end
  end
end
