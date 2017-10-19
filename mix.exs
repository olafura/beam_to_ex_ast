defmodule BeamToExAst.Mixfile do
  use Mix.Project

  def project do
    [app: :beam_to_ex_ast,
     version: "0.0.1",
     elixir: "~> 1.1",
     compilers: Mix.compilers ++ [:protocol_ex],
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:protocol_ex, "~> 0.3.0"},
      {:forms, "~> 0.0.1"},
      {:dogma, "~> 0.0", only: :dev}
    ]
  end
end
