defmodule Fyre.MixProject do
  use Mix.Project

  def project do
    [
      app: :fyre,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications

  def application do

    [
      mod: { Fyre, [] },
      extra_applications: [
        :logger,
        :kafka_ex,
      ],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true}
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1.0"},
      {:uuid, "~> 1.1"},
      {:kafka_ex, "~> 0.9.0"}
    ]
  end
end
