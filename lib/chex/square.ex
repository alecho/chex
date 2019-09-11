defmodule Chex.Square do
  @typedoc """
  File a-h as an atom, with an file integer 1-8.
  """
  @type t :: {file :: atom, rank :: pos_integer}
end
