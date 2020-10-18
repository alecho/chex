defmodule Chex.Parser do
  @moduledoc """
  Behaviour for parsing and serializing chess game data.
  """

  @callback parse(String.t()) :: {:ok, Chex.game()} | {:error, atom()}

  @callback serialize(Chex.game()) :: {:ok, String.t()} | {:error, atom()}

  @callback extension() :: atom()
end
