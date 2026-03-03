defmodule Dave.MixProject do
  use Mix.Project

  def project do
    [
      app: :dave,
      version: "0.1.0",
      elixir: "~> 1.15",
      name: "Dave",
      source_url: "https://github.com/BrandtHill/Dave",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    []
  end

  defp description do
    "Discord DAVE protocol for Elixir, backed by Rust NIF bindings to davey"
  end

  defp deps do
    [
      {:rustler_precompiled, "~> 0.8"},
      {:rustler, "~> 0.37", optional: true, runtime: false},
      {:ex_doc, "~> 0.40", only: :dev, runtime: false}
    ]
  end

  def docs do
    [
      main: "Dave",
      source_ref: "master",
      extras: ["CHANGELOG.md"]
    ]
  end

  defp package do
    [
      name: :dave,
      maintainers: "Brandt Hill",
      licenses: ["MIT"],
      files: [
        "lib",
        "README*",
        "CHANGELOG*",
        "LICENSE*",
        "mix.exs"
      ],
      links: %{
        "GitHub" => "https://github.com/BrandtHill/Dave",
        "Changelog" => "https://hexdocs.pm/dave/changelog.html"
      }
    ]
  end
end
