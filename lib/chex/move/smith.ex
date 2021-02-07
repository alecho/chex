defmodule Chex.Move.Smith do
  @moduledoc false

  alias Chex.Move.{Parser, SmithParser}

  import SmithParser, only: [move: 1]

  @behaviour Parser

  @impl Parser
  def valid?(str) when is_binary(str) do
    case move(str) do
      {:ok, _, "", _, _, _} -> true
      _ -> false
    end
  end

  @impl Parser
  def parse_move(str) do
    case move(str) do
      {:ok, list, _, _, _, _} -> {:ok, list}
      {:error, reason, _, _, _, _} -> {:error, reason}
    end
  end
end
