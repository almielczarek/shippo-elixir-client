defmodule Shippo.Address do
  use Shippo.Resource

  def endpoint, do: "/addresses"

  @doc """
  Creates a Shippo address.

  # Returns
  - An ok-tuple with the address if the address is valid or was not supposed to be validated
  - An invalid-tuple with messages as to why the address is invalid if the address is invalid
  - An error-tuple with the response status and body if Shippo returns an error
  """
  def create(%{validate: true} = params), do: create(Map.new(Enum.map(params, fn {k, v} -> {to_string(k), v} end)))
  def create(%{"validate" => true} = params) do
    case Shippo.post("/addresses", params) do
      %{status: 201, body: %{"validation_results" => %{"is_valid" => true}}} = response ->
        {:ok, response.body}
      %{status: 201} = response ->
        {:invalid, response.body["validation_results"]["messages"]}
      %{status: _} = response ->
        {:error, response.status, response.body}
    end
  end

  def create(params) do
    Shippo.post("/addresses", params)
    |> Shippo.process_response
  end

  @doc """
  Marks an address for validation by the api.

  # Raises
  - If any type other than a map is passed in
  """
  def mark_for_validation(params) when is_map(params), do: Map.put(params, :validate, true)
  def mark_for_validation(data) do
    raise ArgumentError, "This function requires a map. You passed in: #{inspect data}"
  end

  @doc """
  Validates a Shippo address by id.

  Useful if you need to delay validation to a later stage in your application.

  # Returns
  - An ok-tuple with the address if found and valid
  - An invalid-tuple with messages as to why the address is invalid if the address is invalid
  - An error-tuple with the response status and body if Shippo returns an error
  """
  def validate(id) do
    case Shippo.get("/addresses/" <> id <> "/validate") do
      %{status: 200, body: %{"validation_results" => %{"is_valid" => true}}} = response ->
        {:ok, response.body}
      %{status: 200} = response ->
        {:invalid, response.body["validation_results"]["messages"]}
      response ->
        {:error, response.status, response.body}
    end
  end
end
