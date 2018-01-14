defmodule Shippo.Parcel do
  @doc """
  Creates a Shippo parcel.

  # Returns
  - An ok-tuple with the parcel if it was successfully created
  - An error-tuple with the response status and body if Shippo returns an error
  """
  def create(params) do
    Shippo.post("/parcels", params)
    |> Shippo.process_response
  end

  @doc """
  Gets a Shippo parcel by id.

  # Returns
  - The an ok-tuple with the parcel if found
  - An error-tuple with the response status and body if the parcel is not found or Shippo returns an error
  """
  def get(id) do
    Shippo.get("/parcels/" <> id)
    |> Shippo.process_response
  end

  @doc """
  Retrieves the parcels you have submitted to Shippo
  """
  def list do
    case Shippo.get("/parcels") do
      %{status: 200, body: %{"results" => results}} ->
        {:ok, results}
      response ->
        {:error, response.status, response.body}
    end
  end
end
