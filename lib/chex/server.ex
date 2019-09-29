defmodule Chex.Server do
  require Logger
  use GenServer

  def start_link(state) do
    Logger.debug("Chex.Server#start_link called with:")
    Logger.debug(state)
    GenServer.start_link(__MODULE__, state)
  end

  ## Callbacks

  @impl true
  def init(fen: fen) do
    state = Chex.Game.new(fen)
    {:ok, engine} = Chex.Engine.start_link(self())
    state = state |> Map.put(:engine, engine)
    {:ok, state}
  end

  @impl true
  def init(_args) do
    state = Chex.Game.new()
    {:ok, engine} = Chex.Engine.start_link(self())
    state = state |> Map.put(:engine, engine)
    {:ok, state}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:move, move}, _from, state) do
    case Chex.Game.move(state, move) do
      {:ok, state} ->
        {:reply, state, state}

      response ->
        {:reply, response, state}
    end
  end

  @impl true
  def handle_call(:engine_move, _from, state) do
    move =
      state
      |> Map.get(:engine)
      |> GenServer.call({:move, Map.get(state, :fen)}, 15_000)

    {:ok, state} = Chex.Game.move(state, move)
    {:reply, state, state}
  end

  @impl true
  def handle_call(:fen, _from, state) do
    fen = Chex.Game.to_fen(state)
    {:reply, fen, state}
  end

  def handle_cast({:run, cmd}, state) do
    state
    |> Map.get(:engine)
    |> GenServer.cast({:send, cmd <> "\n"})

    {:noreply, state}
  end

  @impl true
  @spec handle_cast({:best_move, String.t()}, Chex.Game.t()) ::
          {:noreply, Chex.Game.t() | {:error, any}}
  def handle_cast({:best_move, move}, game) do
    {from, to} = String.split_at(move, 2)
    from = Chex.Square.from_string(from)
    to = Chex.Square.from_string(to)

    {:ok, game} =
      game
      |> Chex.Game.move({from, to})

    {:noreply, game}
  end
end
