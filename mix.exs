defmodule Chex.MixProject do
  use Mix.Project

  @version "0.1.2"

  def project do
    [
      app: :chex,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
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

  defp description() do
    "A chess library."
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: links(),
      homepage_url: "https://github.com/alecho/chex"
    ]
  end

  defp links() do
    %{
      "GitHub" => "https://github.com/alecho/chex",
      "Readme" => "https://github.com/alecho/chex/blob/v#{@version}/README.md",
      "Changelog" => "https://github.com/alecho/chex/blob/v#{@version}/CHANGELOG.md"
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
      {:credo, "~> 1.5.0-rc.2", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
