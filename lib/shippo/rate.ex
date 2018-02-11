defmodule Shippo.Rate do
  use Shippo.Resource, only: [get: 1]

  def endpoint, do: "/rates"
end
