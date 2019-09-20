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
    state = Map.put(state, :port, port)

    {:noreply, state}
  end

  def handle_info({port, {:data, "id name " <> _rem}}, state) do
    IO.puts("UCI ok recieved")
    state = state |> Map.put(:uci, true)
    Port.command(port, "isready\n")

    {:noreply, state}
  end

  def handle_info({_port, {:data, "readyok" <> _rem}}, state) do
    IO.puts("ready ok recieved")
    state = state |> Map.put(:ready, true)

    {:noreply, state}
  end

  def handle_info({_port, {:data, msg}}, state) do
    if String.contains?(msg, "bestmove") do
      r = ~r/bestmove (?<move>[abcdefgh][1-8][abcdefgh][1-8])/
      %{"move" => move} = Regex.named_captures(r, msg)

      Map.get(state, :respond_to)
      |> GenServer.reply(move)
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

  def handle_call({:move, fen}, from, state) do
    port = state |> Map.get(:port)

    state =
      state
      |> Map.put(:status, :thinking)
      |> Map.put(:respond_to, from)

    Port.command(port, "position fen #{fen}\ngo\n")

    {:noreply, state}
  end

  def terminate(_reason, state) do
    state
    |> Map.get(:port)
    |> Port.close()
  end
end
