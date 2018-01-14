defmodule Shippo.Mixfile do
  use Mix.Project

  def project do
    [app: :shippo,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     source_url: "https://github.com/almielczarek/shippo-elixir-client",
     preferred_cli_env: [
       vcr: :test,
       "vcr.delete": :test,
       "vcr.check": :test,
       "vcr.show": :test
     ],
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:tesla, "~> 0.10.0"},
      {:poison, "~> 3.1"},
      {:exvcr, "~> 0.8", only: :test}
    ]
  end
end
