# Dave

Discord DAVE protocol library via NIF bindings to the `davey` Rust crate

## Installation

The package can be installed by adding `dave` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dave, "~> 0.1.0"}
  ]
end
```

This package depends on `rustler_precompiled` so you don't need a Rust toolchain to compile your projects.

## Purpose

DAVE stands for Discord Audio & Video End-to-End Encryption - perhaps they should have named it DAVEEE. 
It's an E2EE protocol based on MLS that will soon be required by all Discord Voice sessions.

This library defines a number of NIFs that leverage the Rust crate [davey](https://github.com/Snazzah/davey/). 
It is primarily for [nostrum](https://github.com/Kraigie/nostrum), but you may wish to use it to roll your own Elixir Discord library.
Documentation will be limited to little more than type specs for now.

