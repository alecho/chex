# Generated from lib/chex/move/san_parser.ex.exs, do not edit.
# Generated at 2020-11-04 19:11:17Z.

defmodule Chex.Move.SanParser do
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
              move__1: 6,
              move__0: 6,
              move__45: 6,
              move__40: 6,
              move__49: 6,
              move__47: 6,
              move__46: 6,
              move__39: 6,
              move__44: 6,
              move__42: 6,
              move__41: 6,
              move__29: 6,
              move__37: 6,
              move__33: 6,
              move__35: 6,
              move__32: 6,
              move__31: 6,
              move__28: 6,
              move__27: 6,
              move__16: 6,
              move__24: 6,
              move__20: 6,
              move__22: 6,
              move__19: 6,
              move__18: 6,
              move__14: 6,
              move__13: 6,
              move__2: 6,
              move__4: 6,
              move__3: 6,
              move__12: 6,
              move__8: 6,
              move__11: 6,
              move__7: 6,
              move__6: 6
            ]}

  defp move__0(rest, acc, stack, context, line, offset) do
    move__29(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp move__2(rest, acc, stack, context, line, offset) do
    move__3(rest, [], [acc | stack], context, line, offset)
  end

  defp move__3(rest, acc, stack, context, line, offset) do
    move__8(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp move__5(<<"O-O-O", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    move__6(rest, [:queenside] ++ acc, stack, context, comb__line, comb__offset + 5)
  end

  defp move__5(rest, _acc, _stack, context, line, offset) do
    {:error,
     "expected file (a-h) or rank (1-8), followed by capture indicator (x) or square or nothing, followed by capture indicator (x) or nothing, followed by square, followed by promotion indicator (=), followed by piece identifier or En passant indicator (e.p.) or nothing, followed by check indicator (+) or checkmate indicator or nothing or piece identifier, followed by square or file (a-h) or rank (1-8), followed by capture indicator (x) or square or nothing, followed by capture indicator (x) or nothing, followed by square, followed by check indicator (+) or nothing or string \"O-O\", followed by string \"-O\" or string \"O-O-O\"",
     rest, context, line, offset}
  end

  defp move__6(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__4(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__7(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    move__5(rest, [], stack, context, line, offset)
  end

  defp move__8(rest, acc, stack, context, line, offset) do
    move__9(rest, [], [acc | stack], context, line, offset)
  end

  defp move__9(<<"O-O", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    move__10(rest, acc, stack, context, comb__line, comb__offset + 3)
  end

  defp move__9(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    move__7(rest, acc, stack, context, line, offset)
  end

  defp move__10(<<"-O", _::binary>> = rest, acc, stack, context, line, offset) do
    [acc | stack] = stack
    move__7(rest, acc, stack, context, line, offset)
  end

  defp move__10(rest, acc, stack, context, line, offset) do
    move__11(rest, acc, stack, context, line, offset)
  end

  defp move__11(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    move__12(rest, [:kingside] ++ acc, stack, context, line, offset)
  end

  defp move__12(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__4(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__4(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    move__13(
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

  defp move__13(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__1(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__14(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    move__2(rest, [], stack, context, line, offset)
  end

  defp move__15(<<x0::integer, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 82 or x0 === 78 or x0 === 66 or x0 === 81 or x0 === 75 do
    move__16(rest, [piece: [x0]] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp move__15(rest, acc, stack, context, line, offset) do
    move__14(rest, acc, stack, context, line, offset)
  end

  defp move__16(rest, acc, stack, context, line, offset) do
    move__20(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp move__18(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__17(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__19(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    move__18(rest, [], stack, context, line, offset)
  end

  defp move__20(rest, acc, stack, context, line, offset) do
    move__21(rest, [], [acc | stack], context, line, offset)
  end

  defp move__21(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 97 and x0 <= 104 and (x1 >= 49 and x1 <= 56) do
    move__22(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp move__21(<<x0::integer, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 97 and x0 <= 104 do
    move__22(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp move__21(<<x0::integer, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 49 and x0 <= 56 do
    move__22(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp move__21(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    move__19(rest, acc, stack, context, line, offset)
  end

  defp move__22(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    move__23(rest, [origin: :lists.reverse(user_acc)] ++ acc, stack, context, line, offset)
  end

  defp move__23(<<x0::integer, _::binary>> = rest, acc, stack, context, line, offset)
       when x0 === 120 do
    move__24(rest, acc, stack, context, line, offset)
  end

  defp move__23(<<x0::integer, x1::integer, _::binary>> = rest, acc, stack, context, line, offset)
       when x0 >= 97 and x0 <= 104 and (x1 >= 49 and x1 <= 56) do
    move__24(rest, acc, stack, context, line, offset)
  end

  defp move__23(rest, acc, stack, context, line, offset) do
    move__19(rest, acc, stack, context, line, offset)
  end

  defp move__24(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__17(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__17(<<x0::integer, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 120 do
    move__25(rest, [capture: true] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp move__17(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    move__25(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp move__25(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 97 and x0 <= 104 and (x1 >= 49 and x1 <= 56) do
    move__26(rest, [destination: [x0, x1]] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp move__25(rest, acc, stack, context, line, offset) do
    move__14(rest, acc, stack, context, line, offset)
  end

  defp move__26(<<x0::integer, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 43 do
    move__27(rest, [check: true] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp move__26(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    move__27(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp move__27(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__1(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__28(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    move__15(rest, [], stack, context, line, offset)
  end

  defp move__29(rest, acc, stack, context, line, offset) do
    move__33(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp move__31(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__30(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__32(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    move__31(rest, [], stack, context, line, offset)
  end

  defp move__33(rest, acc, stack, context, line, offset) do
    move__34(rest, [], [acc | stack], context, line, offset)
  end

  defp move__34(<<x0::integer, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 97 and x0 <= 104 do
    move__35(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp move__34(<<x0::integer, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 49 and x0 <= 56 do
    move__35(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp move__34(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    move__32(rest, acc, stack, context, line, offset)
  end

  defp move__35(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    move__36(rest, [origin: :lists.reverse(user_acc)] ++ acc, stack, context, line, offset)
  end

  defp move__36(<<x0::integer, _::binary>> = rest, acc, stack, context, line, offset)
       when x0 === 120 do
    move__37(rest, acc, stack, context, line, offset)
  end

  defp move__36(<<x0::integer, x1::integer, _::binary>> = rest, acc, stack, context, line, offset)
       when x0 >= 97 and x0 <= 104 and (x1 >= 49 and x1 <= 56) do
    move__37(rest, acc, stack, context, line, offset)
  end

  defp move__36(rest, acc, stack, context, line, offset) do
    move__32(rest, acc, stack, context, line, offset)
  end

  defp move__37(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__30(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__30(<<x0::integer, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 120 do
    move__38(rest, [capture: true] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp move__30(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    move__38(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp move__38(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 97 and x0 <= 104 and (x1 >= 49 and x1 <= 56) do
    move__39(rest, [destination: [x0, x1]] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp move__38(rest, acc, stack, context, line, offset) do
    move__28(rest, acc, stack, context, line, offset)
  end

  defp move__39(rest, acc, stack, context, line, offset) do
    move__43(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp move__41(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__40(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__42(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    move__41(rest, [], stack, context, line, offset)
  end

  defp move__43(<<"=", x0::integer, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 82 or x0 === 78 or x0 === 66 or x0 === 81 or x0 === 75 do
    move__44(rest, [promote: [x0]] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp move__43(<<"e.p.", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    move__44(rest, [en_passant: true] ++ acc, stack, context, comb__line, comb__offset + 4)
  end

  defp move__43(rest, acc, stack, context, line, offset) do
    move__42(rest, acc, stack, context, line, offset)
  end

  defp move__44(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__40(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__40(rest, acc, stack, context, line, offset) do
    move__48(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp move__46(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__45(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__47(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    move__46(rest, [], stack, context, line, offset)
  end

  defp move__48(<<x0::integer, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 43 do
    move__49(rest, [check: true] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp move__48(<<x0::integer, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 35 do
    move__49(rest, [checkmate: true] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp move__48(rest, acc, stack, context, line, offset) do
    move__47(rest, acc, stack, context, line, offset)
  end

  defp move__49(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__45(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__45(rest, acc, [_, previous_acc | stack], context, line, offset) do
    move__1(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp move__1(rest, acc, _stack, context, line, offset) do
    {:ok, acc, rest, context, line, offset}
  end
end
