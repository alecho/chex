defmodule Chex.MixProject do
  use Mix.Project

  @version "0.1.2"

  @source_url "https://github.com/alecho/chex"

  def project do
    [
      app: :chex,
      version: @version,
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      source_url: @source_url,
      docs: docs(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description() do
    "A chess library."
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: links(),
      homepage_url: @source_url
    ]
  end

  defp links() do
    %{
      "GitHub" => @source_url,
      "Readme" => @source_url <> "/v#{@version}/README.md",
      "Changelog" => @source_url <> "/blob/v#{@version}/CHANGELOG.md"
    }
  end

  defp docs() do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: [
        "README.md",
        "CHANGELOG.md"
      ],
      skip_undefined_reference_warnings_on: ["changelog", "CHANGELOG.md"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:assert_value, "~> 0.9.3", only: [:dev, :test]},
      {:credo, "~> 1.6.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:nimble_parsec, "~> 1.0"}
    ]
  end
end
