defmodule Chex.Move.Parser do
  @moduledoc false

  @callback valid?(String.t()) :: boolean()

  @callback parse_move(String.t()) :: {:ok, keyword()} | {:error, term()}
end
