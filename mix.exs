defmodule Shippo.Mixfile do
  use Mix.Project

  def project do
    [app: :shippo_client,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     source_url: "https://github.com/almielczarek/shippo-elixir-client",
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {Shippo.Application, []}]
  end

  defp deps do
    []
  end

  defp description do
    """
    A client for consuming the Shippo API for the Elixir ecosystem.
    """
  end

  defp package do
    [
      name: :shippo_client,
      maintainers: ["Alexander Mielczarek"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/almielczarek/shippo-elixir-client"}
    ]
  end
end
