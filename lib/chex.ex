defmodule Chex do
  @moduledoc """
  Public API for Chex.
  """

  import DynamicSupervisor, only: [start_child: 2, terminate_child: 2]

  @server_mod Chex.DynamicGameServerSupervisor

  @doc """
  Creates a new game.

  ## Examples

      iex> {:ok, pid} = Chex.new_game()
      iex> pid |> is_pid()
      true

  """
  def new_game(fen) when is_binary(fen) do
    start_child(
      @server_mod,
      {Chex.Server, [fen: fen]}
    )
  end

  def new_game() do
    start_child(
      @server_mod,
      Chex.Server
    )
  end

  @doc """
  End a game process.

  ## Examples

      iex> {:ok, pid} = Chex.new_game()
      iex> pid|> Chex.end_game()
      :ok

  """
  def end_game(pid) do
    terminate_child(
      @server_mod,
      pid
    )
  end
end
