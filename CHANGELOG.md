# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- This CHANGELOG.
- Public API! `Chex`.
- LICENSE file with MIT license.
- Castling support.
- Checkmate support.
- Stalemate support.
- `:pgn` key for games that were imported from a PGN file. This is `nil` or a
map with keys from the tag pair section. Known supported keys such as the STR
are converted to atoms others remain strings.

### Changed

- `Parser.FEN.parse/1` and `Parser.FEN.serialize/1` now return a tuple with
    `{:ok, result}` or `{:error, reason}`.

### Removed

- `:fen` from `%Chex.Game{}`. You can now serialize a game with modules that
    implement the Chex.Parser behaviour like `Chex.Parser.FEN.serialize(game)`.
- OTP application functionality. Users should implement their own state
    management as they see fit for their use case.
- `Game.to_fen` in favor of calling the serializer function directly.
