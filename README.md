# BeamToExAst

[WIP] With this module you can move any code from the Erlang AST to Elixir AST.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add beam_to_ex_ast to your list of dependencies in `mix.exs`:

        def deps do
          [{:beam_to_ex_ast, "~> 0.0.1"}]
        end

  2. Ensure beam_to_ex_ast is started before your application:

        def application do
          [applications: [:beam_to_ex_ast]]
        end
