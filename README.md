# Chex [![Build Status](https://travis-ci.com/alecho/chex.svg?branch=master)](https://travis-ci.com/alecho/chex)

Chess in Elixir.

## Documentation

Full docuemntation is available on hex.pm at [https://hexdocs.pm/chex](https://hexdocs.pm/chex)

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)

## Installation

Add `chex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:chex, "~> 0.1.0"}
  ]
end
```

## Examples

### New Game

```elixir
iex> {:ok, game} = Chex.new_game()
iex(1)> {:ok, game} = Chex.new_game()
{:ok,
 %Chex.Game{
   active_color: :white,
   board: %{
     {:a, 1} => {:rook, :white, {:a, 1}},
     {:a, 2} => {:pawn, :white, {:a, 2}},
     {:a, 7} => {:pawn, :black, {:a, 7}},
     {:a, 8} => {:rook, :black, {:a, 8}},
     {:b, 1} => {:knight, :white, {:b, 1}},
     {:b, 2} => {:pawn, :white, {:b, 2}},
     {:b, 7} => {:pawn, :black, {:b, 7}},
     {:b, 8} => {:knight, :black, {:b, 8}},
     {:c, 1} => {:bishop, :white, {:c, 1}},
     {:c, 2} => {:pawn, :white, {:c, 2}},
     {:c, 7} => {:pawn, :black, {:c, 7}},
     {:c, 8} => {:bishop, :black, {:c, 8}},
     {:d, 1} => {:queen, :white, {:d, 1}},
     {:d, 2} => {:pawn, :white, {:d, 2}},
     {:d, 7} => {:pawn, :black, {:d, 7}},
     {:d, 8} => {:queen, :black, {:d, 8}},
     {:e, 1} => {:king, :white, {:e, 1}},
     {:e, 2} => {:pawn, :white, {:e, 2}},
     {:e, 7} => {:pawn, :black, {:e, 7}},
     {:e, 8} => {:king, :black, {:e, 8}},
     {:f, 1} => {:bishop, :white, {:f, 1}},
     {:f, 2} => {:pawn, :white, {:f, 2}},
     {:f, 7} => {:pawn, :black, {:f, 7}},
     {:f, 8} => {:bishop, :black, {:f, 8}},
     {:g, 1} => {:knight, :white, {:g, 1}},
     {:g, 2} => {:pawn, :white, {:g, 2}},
     {:g, 7} => {:pawn, :black, {:g, 7}},
     {:g, 8} => {:knight, :black, {:g, 8}},
     {:h, 1} => {:rook, :white, {:h, 1}},
     {:h, 2} => {:pawn, :white, {:h, 2}},
     {:h, 7} => {:pawn, :black, {:h, 7}},
     {:h, 8} => {:rook, :black, {:h, 8}}
   },
   captures: [],
   castling: [:K, :Q, :k, :q],
   check: nil,
   en_passant: nil,
   fullmove_clock: 1,
   halfmove_clock: 0,
   moves: [],
   result: nil
 }}
```

### Out of Turn Move
```elixir
iex> Chex.make_move(game, "e7e5")
{:error, :out_of_turn}
```

### Making Moves
```elixir
iex> {:ok, game} = Chex.make_move(game, "e2e4")
iex> game.active_color
:black
iex> game.moves
[{{:e, 2}, {:e, 4}}]
iex> {:ok, game} = Chex.make_move(game, "e7e5")
iex> game.en_passant
{:e, 6}
iex> game.fullmove_clock
2
iex> game.moves
[{{:e, 7}, {:e, 5}}, {{:e, 2}, {:e, 4}}]
```

### Invalid Move
```elixir
Chex.make_move(game, "e4e5")
{:error, :invalid_move}
{:ok, game} = Chex.make_move(game, "d2d4")
```

### Capturing
```elixir
{:ok, game} = Chex.make_move(game, "e5d4")
game.captures
[pawn: :white]
```

### Check & Mate

```elixir
# Scholar's Mate
iex> {:ok, game} = Chex.new_game()
iex> {:ok, game} = Chex.make_move(game, "e2e4")
iex> {:ok, game} = Chex.make_move(game, "e7e5")
iex> {:ok, game} = Chex.make_move(game, "f1c4")
iex> {:ok, game} = Chex.make_move(game, "b8c6")
iex> {:ok, game} = Chex.make_move(game, "d1h5")
iex> {:ok, game} = Chex.make_move(game, "g8f6")
iex> {:ok, game} = Chex.make_move(game, "h5f7")
iex> game.check
:black
iex> game.result
:white
```

