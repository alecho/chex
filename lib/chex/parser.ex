defmodule Chex.Parser do
  alias Chex.Game

  @moduledoc """
  Behaviour for parsing and serializing chess game data.
  """

  @callback parse(String.t()) :: {:ok, Game.t()} | {:error, atom()}

  @callback serialize(Game.t()) :: {:ok, String.t()} | {:error, atom()}

  @callback extension() :: atom()
end
