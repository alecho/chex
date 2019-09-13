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
end
