defmodule BeamToExAst.Mixfile do
  use Mix.Project

  def project do
    [
      app: :beam_to_ex_ast,
      version: "0.4.1",
      elixir: "~> 1.1",
      description: "Beam AST to Elixir AST transpiler",
      package: package(),
      compilers: Mix.compilers(),
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      extra_applications: [:logger],
      deps: deps()
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Olafur Arason"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/olafura/beam_to_ex_ast"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

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
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:forms, "~> 0.0.1"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
