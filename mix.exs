defmodule Chex.MixProject do
  use Mix.Project

  def project do
    [
      app: :chex,
      version: "0.1.2",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "A chess library."
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/alecho/chex"},
      homepage_url: "https://github.com/alecho/chex"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:assert_value, "~> 0.9.3", only: [:dev, :test]},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
