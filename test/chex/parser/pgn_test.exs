defmodule Chex.Parser.PGNTest do
  use ExUnit.Case, async: true
  doctest Chex.Parser.PGN

  alias Chex.Parser.PGN

  setup_all do
    {:ok, game} =
      "./test/chex/parser/pgn_data/anderssen_kieseritzky_1851.pgn"
      |> Path.expand()
      |> File.read!()
      |> PGN.parse()

    [game: game]
  end

  describe "parsing Anderssen v. Kieseritzky, 1851" do
    test "calulates check state", %{game: game} do
      assert game.check == :black
    end

    test "calulates active color", %{game: game} do
      assert game.active_color == :black
    end

    test "reads result", %{game: game} do
      assert game.result == :white
    end

    test "puts moves in game", %{game: game} do
      assert length(game.moves) == 45
    end

    test "stores pgn moves", %{game: game} do
      assert length(game.pgn.moves) == 45
    end

    test "parses STR", %{game: game} do
      assert game.pgn.event == "London"
      assert game.pgn.site == "London ENG"
      assert game.pgn.date == "1851.06.21"
      assert game.pgn.round == "?"
      assert game.pgn.white == "Adolf Anderssen"
      assert game.pgn.black == "Lionel Adalbert Bagration Felix Kieseritzky"
      assert game.pgn.result == "1-0"
    end

    test "reads ECO tag name", %{game: game} do
      assert game.pgn.eco == "C33"
    end

    test "reads WhiteElo tag name", %{game: game} do
      assert game.pgn.white_elo == "?"
    end

    test "reads BlackElo tag name", %{game: game} do
      assert game.pgn.black_elo == "?"
    end

    test "reads PlyCount tag name", %{game: game} do
      assert game.pgn.ply_count == "45"
    end

    test "reads calulates en passant", %{game: game} do
      assert game.en_passant == nil
    end

    test "calculates fullmove_clock", %{game: game} do
      assert game.fullmove_clock == 23
    end

    test "calculates halfmove_clock", %{game: game} do
      assert game.halfmove_clock == 1
    end
  end
end
