defmodule Shippo.Transaction do
  use Shippo.Resource

  def endpoint, do: "/transactions"

  @doc """
  Creates a Shippo transaction (purchases a label).

  # Returns
  - An ok-tuple with the transaction if the shipment or rate passed in is valid
  - An error-tuple with the response status and body if Shippo returns an error
  """
  def create(shipment_or_rate, params \\ %{}), do: create_impl(shipment_or_rate, params)

  defp create_impl(shipment, params) when is_map(shipment) do
    case Shippo.post(endpoint(), Map.merge(shipment, params)) do
      %{status: 201} = response ->
        {:ok, response.body}

      %{status: 200} = response ->
        {:ok, response.body}

      %{status: _} = response ->
        {:error, response.status, response.body}
    end
  end

  defp create_impl(rate_id, params) do
    case Shippo.post(endpoint(), Map.put(params, :rate, rate_id)) do
      %{status: 201} = response ->
        {:ok, response.body}

      %{status: 200} = response ->
        {:ok, response.body}

      %{status: _} = response ->
        {:error, response.status, response.body}
    end
  end
end
