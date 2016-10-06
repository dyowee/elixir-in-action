defmodule Todo.Mixfile do
  use Mix.Project

  def project do
    [app: :todo,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:gproc, :cowboy, :plug],
     mod: {Todo.Application, []}]
  end

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
      {:gproc, "0.3.1"},
      {:plug, "0.10.0"},
      {:cowboy, "1.0.0"},      
      {:meck, "0.8.2", only: :test},
      {:httpoison, "0.4.3", only: :test},
      {:exrm, "0.19.0"}
    ]
  end
end
