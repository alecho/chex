# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- `Parser.FEN.parse/1` and `Parser.FEN.serialize/1` now return a tuple with
  `{:ok, result}` or `{:error, reason}`.

### Removed

- `:fen` from `%Chex.Game{}`. You can now serialize a game with modules that
  implement the Chex.Parser behaviour like `Chex.Parser.FEN.serialize(game)`.