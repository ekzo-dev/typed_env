# Changelog

All notable changes to this gem are recorded here. The format is [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the versions follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-11-07

First release on rubygems.org. Until now the gem was installed from GitHub as `env_settings`, module `EnvSettings`
(the name is another gem's on rubygems.org): it is `typed_env`, module `TypedEnv`, from this version on —
`EnvSettings::Base` becomes `TypedEnv::Base`, `EnvSettings::ValidationError` `TypedEnv::ValidationError`.

### Added

- The `var` DSL: typed environment variables (`string`, `integer`, `float`, `boolean`, `array`, `hash`, `symbol`) with
  defaults, `name?` for booleans, `name_present?`, `all` / `to_h`.
- Validations: presence, length, format and inclusion built in; every ActiveModel validation when ActiveModel is loaded.
  `validate!` checks every var; a value written is validated before it is written.
- Reader and writer callbacks, per var and default for the class: settings kept elsewhere than `ENV`. Read-only
  without a writer.

### Fixed

- `validate!` with ActiveModel ran every var's rules N + 1 times (a full validation, then each var again, each time
  all rules); now once.
- A rule could not read a var declared after it without rules of its own (`if: -> { other }` raised `NameError`).
- The validator kept a value in an instance variable per setting, which gave its class a shape per setting: Ruby 3.4
  warned "reached 8 shape variations" at boot for more than eight validated vars.
- README: writer examples used the `key` parameter callbacks no longer receive.
