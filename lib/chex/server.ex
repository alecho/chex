defmodule Chex.Server do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  ## Callbacks

  @impl true
  def init(fen: fen) do
    {:ok, Chex.Game.new(fen)}
  end

  @impl true
  def init(_args) do
    {:ok, Chex.Game.new()}
  end

  @impl true
  def handle_call(:ping, _from, state) do
    {:reply, :pong, state}
  end

  @impl true
  @spec handle_cast({:best_move, String.t()}, Chex.Game.t()) ::
          {:noreply, Chex.Game.t()}
  def handle_cast({:best_move, move}, game) do
    {from, to} = String.split_at(move, 2)
    from = Chex.Square.from_string(from)
    to = Chex.Square.from_string(to)
    IO.inspect(from)
    IO.inspect(to)

    game =
      game
      |> Chex.Game.move(from, to)

    # If move successfull, tell the engine

    {:noreply, game}
  end
end
