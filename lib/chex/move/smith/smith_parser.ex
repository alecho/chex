# Generated from lib/chex/move/smith/smith_parser.ex.exs, do not edit.
# Generated at 2020-11-10 17:54:19Z.

defmodule Chex.Move.SmithParser do
  @moduledoc false

  @doc """
  Parses the given `binary` as move.

  Returns `{:ok, [token], rest, context, position, byte_offset}` or
  `{:error, reason, rest, context, line, byte_offset}` where `position`
  describes the location of the move (start position) as `{line, column_on_line}`.

  ## Options

    * `:byte_offset` - the byte offset for the whole binary, defaults to 0
    * `:line` - the line and the byte offset into that line, defaults to `{1, byte_offset}`
    * `:context` - the initial context value. It will be converted to a map

  """
  @spec move(binary, keyword) ::
          {:ok, [term], rest, context, line, byte_offset}
          | {:error, reason, rest, context, line, byte_offset}
        when line: {pos_integer, byte_offset},
             byte_offset: pos_integer,
             rest: binary,
             reason: String.t(),
             context: map()
  def move(binary, opts \\ []) when is_binary(binary) do
    context = Map.new(Keyword.get(opts, :context, []))
    byte_offset = Keyword.get(opts, :byte_offset, 0)

    line =
      case(Keyword.get(opts, :line, 1)) do
        {_, _} = line ->
          line

        line ->
          {line, byte_offset}
      end

    case(move__0(binary, [], [], context, line, byte_offset)) do
      {:ok, acc, rest, context, line, offset} ->
        {:ok, :lists.reverse(acc), rest, context, line, offset}

      {:error, _, _, _, _, _} = error ->
        error
    end
  end

  @compile {:inline,
            [
              move__19: 6,
              move__0: 6,
              move__18: 6,
              move__15: 6,
              move__14: 6,
              move__9: 6,
              move__13: 6,
              move__10: 6,
              move__12: 6,
              move__8: 6,
              move__7: 6,
              move__2: 6,
              move__6: 6,
              move__3: 6,
              move__5: 6
            ]}

  defp move__0(rest, acc, stack, context, line, offset) do
    move__16(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp move__2(rest, acc, stack, context, line, offset) do
    move__3(rest, [], [acc | stack], context, line, offset)
  end

  defp move__3(rest, acc, stack, context, line, offset) do
    move__4(rest, [], [acc | stack], context, line, offset)
  end

  defp move__4(<<"e1c1c", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    move__5(rest, acc, stack, context, comb__line, comb__offset + 5)
  end

  defp move__4(<<"e8c8c", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    move__5(rest, acc, stack, context, comb__line, comb__offset + 5)
  end

  defp move__4(rest, _acc, _stack, context, line, offset) do
    {:error,
     "expected square, followed by square, followed by utf8 codepoint equal to 'c' or string \"e1g1c\" or string \"e8g8c\" or string \"e1c1c\" or string \"e8c8c\"",
     rest, context, line, offset}
  end

  defp move__5(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    move__6(rest, [:queenside] ++ acc, stack, context, line, offset)
  end

  defp move__6(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    move__7(
      rest,
      [
        castle:
          case(:lists.reverse(user_acc)) do
            [one] ->
              one

            many ->
              raise("unwrap_and_tag/3 expected a single token, got: #{inspect(many)}")
          end
      ] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp move__7(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__1(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__8(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    move__2(rest, [], stack, context, line, offset)
  end

  defp move__9(rest, acc, stack, context, line, offset) do
    move__10(rest, [], [acc | stack], context, line, offset)
  end

  defp move__10(rest, acc, stack, context, line, offset) do
    move__11(rest, [], [acc | stack], context, line, offset)
  end

  defp move__11(<<"e1g1c", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    move__12(rest, acc, stack, context, comb__line, comb__offset + 5)
  end

  defp move__11(<<"e8g8c", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    move__12(rest, acc, stack, context, comb__line, comb__offset + 5)
  end

  defp move__11(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    move__8(rest, acc, stack, context, line, offset)
  end

  defp move__12(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    move__13(rest, [:kingside] ++ acc, stack, context, line, offset)
  end

  defp move__13(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    move__14(
      rest,
      [
        castle:
          case(:lists.reverse(user_acc)) do
            [one] ->
              one

            many ->
              raise("unwrap_and_tag/3 expected a single token, got: #{inspect(many)}")
          end
      ] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp move__14(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__1(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__15(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    move__9(rest, [], stack, context, line, offset)
  end

  defp move__16(
         <<x0::utf8, x1::utf8, x2::utf8, x3::utf8, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 97 and x0 <= 104 and (x1 >= 49 and x1 <= 56) and (x2 >= 97 and x2 <= 104) and
              (x3 >= 49 and x3 <= 56) do
    move__17(
      rest,
      [destination: [x2, x3], origin: [x0, x1]] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + byte_size(<<x0::utf8>>) + byte_size(<<x1::utf8>>) + byte_size(<<x2::utf8>>) +
        byte_size(<<x3::utf8>>)
    )
  end

  defp move__16(rest, acc, stack, context, line, offset) do
    move__15(rest, acc, stack, context, line, offset)
  end

  defp move__17(<<x0::utf8, _::binary>> = rest, acc, stack, context, line, offset)
       when x0 === 99 do
    move__15(rest, acc, stack, context, line, offset)
  end

  defp move__17(rest, acc, stack, context, line, offset) do
    move__18(rest, acc, stack, context, line, offset)
  end

  defp move__18(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__1(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__1(<<x0::utf8, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 114 or x0 === 110 or x0 === 98 or x0 === 113 or x0 === 107 do
    move__19(
      rest,
      [promote: [x0]] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + byte_size(<<x0::utf8>>)
    )
  end

  defp move__1(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    move__19(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp move__19(rest, acc, _stack, context, line, offset) do
    {:ok, acc, rest, context, line, offset}
  end
end
