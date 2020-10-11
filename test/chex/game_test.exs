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
      assert {:ok, _game} = Game.move(game, "e2e4")
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

    test "updates :active_color" do
      {:ok, game} = Game.new()
      assert game.active_color == :white
      {:ok, game} = Game.move(game, "e2e4")
      assert game.active_color == :black
      {:ok, game} = Game.move(game, "e7e5")
      assert game.active_color == :white
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

    test "updates :fullmove_clock" do
      {:ok, game} = Game.new()
      assert game.fullmove_clock == 1
      {:ok, game} = Game.move(game, "g1f3")
      assert game.fullmove_clock == 1
      {:ok, game} = Game.move(game, "g8f6")
      assert game.fullmove_clock == 2
      {:ok, game} = Game.move(game, "b1c3")
      assert game.fullmove_clock == 2
      {:ok, game} = Game.move(game, "b8c6")
      assert game.fullmove_clock == 3
    end

    test "adds captured piece to captures" do
      {:ok, game} = Game.new()
      {:ok, game} = Game.move(game, "g1f3")
      {:ok, game} = Game.move(game, "b8c6")
      {:ok, game} = Game.move(game, "f3d4")
      {:ok, game} = Game.move(game, "c6d4")
      assert game.captures == [{:knight, :white}]
    end

    test "removes castling rights when castling" do
      {:ok, game} = Game.new("rnbqk2r/pppp1ppp/5n2/2b1p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4")
      {:ok, game} = Game.move(game, "e1g1")
      assert game.castling == [:k, :q]
      {:ok, game} = Game.move(game, "e8g8")
      assert game.castling == []
    end

    test "removes castling rights when king moves" do
      {:ok, game} = Game.new("rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2")
      {:ok, game} = Game.move(game, "e1e2")
      assert game.castling == [:k, :q]
      {:ok, game} = Game.move(game, "e8e7")
      assert game.castling == []
    end

    test "removes kingside castling rights when kingside rook moves" do
      {:ok, game} = Game.new("rnbqkbnr/ppppppp1/8/7p/7P/8/PPPPPPP1/RNBQKBNR w KQkq h6 0 2")
      {:ok, game} = Game.move(game, "h1h3")
      assert game.castling == [:Q, :k, :q]
      {:ok, game} = Game.move(game, "h8h6")
      assert game.castling == [:Q, :q]
    end

    test "removes queenside castling rights when queenside rook moves" do
      {:ok, game} = Game.new("rnbqkbnr/1ppppppp/8/p7/P7/8/1PPPPPPP/RNBQKBNR w KQkq a6 0 2")
      {:ok, game} = Game.move(game, "a1a3")
      assert game.castling == [:K, :k, :q]
      {:ok, game} = Game.move(game, "a8a6")
      assert game.castling == [:K, :k]
    end

    test "adds the color in check when a check occurs" do
      {:ok, game} = Game.new("4k3/8/8/8/8/8/8/4KQ2 w - - 0 1")
      {:ok, game} = Game.move(game, "f1e2")
      assert game.check == :black
    end

    test "sets check to nil when moving out of check" do
      {:ok, game} = Game.new("4k3/8/8/8/8/8/8/4KQ2 w - - 0 1")
      {:ok, game} = Game.move(game, "f1e2")
      {:ok, game} = Game.move(game, "e8d8")
      assert game.check == nil
    end

    test "promotes pawn to queen when piece is not specified" do
      {:ok, game} = Game.new("k7/4P3/8/8/8/8/3p4/K7 w - - 0 1")
      {:ok, game} = Game.move(game, "e7e8")
      assert {:queen, :white, {:e, 7}} = Map.get(game.board, {:e, 8})
      {:ok, game} = Game.move(game, "d2d1")
      assert {:queen, :black, {:d, 2}} = Map.get(game.board, {:d, 1})
    end

    test "promotes pawn to the specified piece" do
      {:ok, game} = Game.new("k7/4P3/8/8/8/8/3p4/K7 w - - 0 1")
      {:ok, game} = Game.move(game, "e7e8", :rook)
      assert {:rook, :white, {:e, 7}} = Map.get(game.board, {:e, 8})
      {:ok, game} = Game.move(game, "d2d1", :bishop)
      assert {:bishop, :black, {:d, 2}} = Map.get(game.board, {:d, 1})
    end

    test "doesn't promote other pieces" do
      {:ok, game} = Game.new("k7/4R3/8/8/8/8/3p4/K7 w - - 0 1")
      {:ok, game} = Game.move(game, "e7e8")
      assert {:rook, :white, {:e, 7}} = Map.get(game.board, {:e, 8})
    end

    test "promoting pawn to queen may check" do
      {:ok, game} = Game.new("k7/4P3/8/8/8/8/3p4/K7 w - - 0 1")
      {:ok, game} = Game.move(game, "e7e8")
      assert game.check == :black
    end
  end

  describe "castling" do
    test "white kingside castle" do
      {:ok, game} = Game.new("r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1")

      assert Game.move(game, "e1g1") ==
               {:ok,
                %Chex.Game{
                  active_color: :black,
                  board: %{
                    :__struct__ => Chex.Board,
                    {:a, 1} => {:rook, :white, {:a, 1}},
                    {:a, 8} => {:rook, :black, {:a, 8}},
                    {:e, 1} => nil,
                    {:e, 8} => {:king, :black, {:e, 8}},
                    {:f, 1} => {:rook, :white, {:h, 1}},
                    {:g, 1} => {:king, :white, {:e, 1}},
                    {:h, 1} => nil,
                    {:h, 8} => {:rook, :black, {:h, 8}}
                  },
                  captures: [],
                  castling: [:k, :q],
                  check: nil,
                  en_passant: nil,
                  fullmove_clock: 1,
                  halfmove_clock: 1,
                  moves: [{{:e, 1}, {:g, 1}}]
                }}
    end

    test "black kingside castle" do
      {:ok, game} = Game.new("r3k2r/8/8/8/8/8/8/R3K2R b KQkq - 0 1")

      assert Game.move(game, "e8g8") ==
               {:ok,
                %Chex.Game{
                  active_color: :white,
                  board: %{
                    :__struct__ => Chex.Board,
                    {:a, 1} => {:rook, :white, {:a, 1}},
                    {:a, 8} => {:rook, :black, {:a, 8}},
                    {:e, 1} => {:king, :white, {:e, 1}},
                    {:e, 8} => nil,
                    {:f, 8} => {:rook, :black, {:h, 8}},
                    {:g, 8} => {:king, :black, {:e, 8}},
                    {:h, 1} => {:rook, :white, {:h, 1}},
                    {:h, 8} => nil
                  },
                  captures: [],
                  castling: [:K, :Q],
                  check: nil,
                  en_passant: nil,
                  fullmove_clock: 2,
                  halfmove_clock: 1,
                  moves: [{{:e, 8}, {:g, 8}}]
                }}
    end

    test "white queenside castle" do
      {:ok, game} = Game.new("r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1")

      assert Game.move(game, "e1c1") ==
               {:ok,
                %Chex.Game{
                  active_color: :black,
                  board: %{
                    :__struct__ => Chex.Board,
                    {:a, 1} => nil,
                    {:a, 8} => {:rook, :black, {:a, 8}},
                    {:c, 1} => {:king, :white, {:e, 1}},
                    {:d, 1} => {:rook, :white, {:a, 1}},
                    {:e, 1} => nil,
                    {:e, 8} => {:king, :black, {:e, 8}},
                    {:h, 1} => {:rook, :white, {:h, 1}},
                    {:h, 8} => {:rook, :black, {:h, 8}}
                  },
                  captures: [],
                  castling: [:k, :q],
                  check: nil,
                  en_passant: nil,
                  fullmove_clock: 1,
                  halfmove_clock: 1,
                  moves: [{{:e, 1}, {:c, 1}}]
                }}
    end

    test "black queenside castle" do
      {:ok, game} = Game.new("r3k2r/8/8/8/8/8/8/R3K2R b KQkq - 0 1")

      assert Game.move(game, "e8c8") ==
               {:ok,
                %Chex.Game{
                  active_color: :white,
                  board: %{
                    :__struct__ => Chex.Board,
                    {:a, 1} => {:rook, :white, {:a, 1}},
                    {:a, 8} => nil,
                    {:c, 8} => {:king, :black, {:e, 8}},
                    {:d, 8} => {:rook, :black, {:a, 8}},
                    {:e, 1} => {:king, :white, {:e, 1}},
                    {:e, 8} => nil,
                    {:h, 1} => {:rook, :white, {:h, 1}},
                    {:h, 8} => {:rook, :black, {:h, 8}}
                  },
                  captures: [],
                  castling: [:K, :Q],
                  check: nil,
                  en_passant: nil,
                  fullmove_clock: 2,
                  halfmove_clock: 1,
                  moves: [{{:e, 8}, {:c, 8}}]
                }}
    end
  end
end
