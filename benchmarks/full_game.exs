defmodule FullGame do
  def immortal_game() do
    {:ok, game} = Chex.new_game()

    {:ok, game} = Chex.make_move(game, "e2e4")
    {:ok, game} = Chex.make_move(game, "e7e5")

    {:ok, game} = Chex.make_move(game, "f2f4")
    {:ok, game} = Chex.make_move(game, "e5f4")

    {:ok, game} = Chex.make_move(game, "f1c4")
    {:ok, game} = Chex.make_move(game, "d8h4")

    {:ok, game} = Chex.make_move(game, "e1f1")
    {:ok, game} = Chex.make_move(game, "b7b5")

    {:ok, game} = Chex.make_move(game, "c4b5")
    {:ok, game} = Chex.make_move(game, "g8f6")

    {:ok, game} = Chex.make_move(game, "g1f3")
    {:ok, game} = Chex.make_move(game, "h4h6")

    {:ok, game} = Chex.make_move(game, "d2d3")
    {:ok, game} = Chex.make_move(game, "f6h5")

    {:ok, game} = Chex.make_move(game, "f3h4")
    {:ok, game} = Chex.make_move(game, "h6g5")

    {:ok, game} = Chex.make_move(game, "h4f5")
    {:ok, game} = Chex.make_move(game, "c7c6")

    {:ok, game} = Chex.make_move(game, "g2g4")
    {:ok, game} = Chex.make_move(game, "h5f6")

    {:ok, game} = Chex.make_move(game, "h1g1")
    {:ok, game} = Chex.make_move(game, "c6b5")

    {:ok, game} = Chex.make_move(game, "h2h4")
    {:ok, game} = Chex.make_move(game, "g5g6")

    {:ok, game} = Chex.make_move(game, "h4h5")
    {:ok, game} = Chex.make_move(game, "g6g5")

    {:ok, game} = Chex.make_move(game, "d1f3")
    {:ok, game} = Chex.make_move(game, "f6g8")

    {:ok, game} = Chex.make_move(game, "c1f4")
    {:ok, game} = Chex.make_move(game, "g5f6")

    {:ok, game} = Chex.make_move(game, "b1c3")
    {:ok, game} = Chex.make_move(game, "f8c5")

    {:ok, game} = Chex.make_move(game, "c3d5")
    {:ok, game} = Chex.make_move(game, "f6b2")

    {:ok, game} = Chex.make_move(game, "f4d6")
    {:ok, game} = Chex.make_move(game, "c5g1")

    {:ok, game} = Chex.make_move(game, "e4e5")
    {:ok, game} = Chex.make_move(game, "b2a1")

    {:ok, game} = Chex.make_move(game, "f1e2")
    {:ok, game} = Chex.make_move(game, "b8a6")

    {:ok, game} = Chex.make_move(game, "f5g7")
    {:ok, game} = Chex.make_move(game, "e8d8")

    {:ok, game} = Chex.make_move(game, "f3f6")
    {:ok, game} = Chex.make_move(game, "g8f6")

    {:ok, game} = Chex.make_move(game, "d6e7")
  end
end

Benchee.run(
  %{
    "immortal_game" => fn -> FullGame.immortal_game() end
  },
  warmup: 5,
  time: 15,
  memory_time: 2,
  save: [path: "benchmarks/save.benchee", tag: "master"],
  load: "benchmarks/save.benchee"
)
