defmodule Chex.Engine do
  use GenServer

  def start_link(respond_to) do
    GenServer.start_link(__MODULE__, respond_to)
  end

  def init(respond_to) when is_pid(respond_to) do
    state = %{
      respond_to: respond_to,
      uci: false,
      ready: false,
      port: nil
    }

    {:ok, state, {:continue, :start_engine}}
  end

  def handle_continue(:start_engine, state) do
    port = Port.open({:spawn, "stockfish"}, [:binary])
    Port.command(port, "uci\n")
    Port.command(port, "isready\n")
    state = Map.put(state, :port, port)
    {:noreply, state}
  end

  def handle_info({_port, {:data, msg}}, state) do
    state =
      cond do
        msg |> String.contains?("uciok") ->
          state |> Map.put(:uci, true)

        msg |> String.contains?("readyok") ->
          state |> Map.put(:ready, true)

        msg |> String.contains?("bestmove") ->
          r = ~r/bestmove (?<move>[abcdefgh][1-8][abcdefgh][1-8])/
          %{"move" => move} = Regex.named_captures(r, msg)

          Map.get(state, :respond_to)
          |> GenServer.cast({:best_move, move})

          state

        true ->
          state
      end

    {:noreply, state}
  end

  def handle_cast({:send, command}, state) do
    state
    |> Map.get(:port)
    |> Port.command(command <> "\n")

    state
    |> Map.put(:status, :thinking)

    {:noreply, state}
  end

  def handle_call({:send, command}, from, state) do
    state
    |> Map.get(:port)
    |> Port.command(command <> "\n")

    state
    |> Map.put(:status, :thinking)
    |> Map.put(:best_move, nil)
    |> Map.put(:from, from)

    IO.inspect(state)
    {:reply, :thinking, state}
  end

  def terminate(_reason, state) do
    state
    |> Map.get(:port)
    |> Port.close()
  end
end
