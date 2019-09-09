defmodule Chex.Server do
  use GenServer

  def start_link(count) do
    GenServer.start_link(__MODULE__, count)
  end

  ## Callbacks

  @impl true
  def init(count) do
    {:ok, count}
  end

  @impl true
  def handle_call(:ping, _from, count) do
    {:reply, :pong, count + 1}
  end
end
