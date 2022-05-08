defmodule Tadot.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :tadot,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:porcelain, "~> 2.0"}
    ]
  end

  defp escript do
    [main_module: Tadot.CLI]
  end
end
