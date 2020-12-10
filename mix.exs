defmodule CardAccess.MixProject do
  use Mix.Project

  def project do
    [
      app: :card_access,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CardAccess.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}

      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},

      {:csv, "~> 2.3"},
      {:phoenix, "~> 1.5.1"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_live_view, "~> 0.14.7"},

      {:jason, "~> 1.0"}
    ]
  end
end
