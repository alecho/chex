defmodule Chex.Engine do
  @moduledoc """
  Basic UCI engine implementation.
  """
  require Logger
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
    port =
      Port.open({:spawn, Application.get_env(:chex, :engine_path, "/usr/local/bin/stockfish")}, [
        :binary
      ])

    Port.command(port, "uci\n")
    state = Map.put(state, :port, port)

    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :port, _object, reason}, state) do
    Logger.debug("Engine crashed because: #{reason}")

    {:noreply, state}
  end

  def handle_info({port, {:data, "id name " <> _rem}}, state) do
    Logger.debug("Engine UCI ok")
    state = state |> Map.put(:uci, true)
    Port.command(port, "isready\n")

    {:noreply, state}
  end

  def handle_info({port, {:data, "readyok" <> _rem}}, state) do
    Logger.debug("Engine is ready")
    state = state |> Map.put(:ready, true)
    Port.command(port, "setoption name Minimum Thinking Time value 500\n")

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

  def handle_info(_msg, state), do: {:noreply, state}

  def handle_cast({:send, command}, state) do
    state
    |> Map.get(:port)
    |> Port.command(command <> "\n")

    state
    |> Map.put(:status, :thinking)

    {:noreply, state}
  end

  def handle_cast({:set_option, {option, value}}, state) do
    state
    |> Map.get(:port)
    |> Port.command("setoption name #{option} value #{value}\n")

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
