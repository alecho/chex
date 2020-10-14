# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- This CHANGELOG.
- LICENSE file with MIT license.
- `Piece.trim/1` to remove starting square from a three element tuple
    containing a piece name, color, and starting square.
- `Queen`, `Bishop`, `Knight`, and `Rook` modules.
- `Board.find_piece/2` and `Board.find_pieces/2`.
- `Chex.Color` with a `flip/1`.
- `Piece.King` is now castling aware and provides the castling square(s) in it's
    `available_moves/3`.
- `Board.get_piece_name/2` to get just the name of a piece at a square.
- Castling support.

### Changed

- `Parser.FEN.parse/1` and `Parser.FEN.serialize/1` now return a tuple with
    `{:ok, result}` or `{:error, reason}`.
- `Chex.Piece.Movement.walk` now considers the game state and only returns
- `Chex.Piece.possible_moves` now takes game state and a square and returns a
    list of squares.
- Moved private functions `Game.pickup_piece.2` and `Game.place_piece/3` to
    public functions under the `Board` module.
- Board API functions to take a Game struct or map with `:board` key instead of
    the removed board struct.

### Removed

- `:fen` from `%Chex.Game{}`. You can now serialize a game with modules that
    implement the Chex.Parser behaviour like `Chex.Parser.FEN.serialize(game)`.
- OTP application functionality. Users should implement their own state
    management as they see fit for their use case.
- `Board.new/0`. There's little reason to use a struct for the board
    representation and no reason to populate it with 64 keys that point to a nil
    value.
