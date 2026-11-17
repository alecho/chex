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

- **Breaking:** raise the minimum Elixir version from 1.9 to 1.16, dropping
  upstream-unsupported Elixir 1.9–1.15. Consumers on those releases must upgrade
  Elixir or retain an earlier Chex release. CI now covers supported Elixir
  1.16–1.20 with compatible OTP versions.
- Development tooling requires Elixir 1.18+; formatting, strict Credo, and
  documentation are verified on Elixir 1.20.5.

- `Parser.FEN.parse/1` and `Parser.FEN.serialize/1` now return a tuple with
    `{:ok, result}` or `{:error, reason}`.

### Removed

- `:fen` from `%Chex.Game{}`. You can now serialize a game with modules that
    implement the Chex.Parser behaviour like `Chex.Parser.FEN.serialize(game)`.
- OTP application functionality. Users should implement their own state
    management as they see fit for their use case.
- `Game.to_fen` in favor of calling the serializer function directly.
