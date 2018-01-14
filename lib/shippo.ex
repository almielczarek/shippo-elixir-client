defmodule Shippo do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.goshippo.com"
  plug Tesla.Middleware.Headers, %{"Authorization" => "ShippoToken #{api_key()}"}
  plug Tesla.Middleware.JSON

  @doc false
  def process_response(response) do
    case response do
      %{status: 200} ->
        {:ok, response.body}
      %{status: 201} ->
        {:ok, response.body}
      _ ->
        {:error, response.status, response.body}
    end
  end

  defp api_key do
    from_config = Application.get_env(:shippo, :api_key)
    from_env = System.get_env("SHIPPO_KEY")

    cond do
      is_nil(from_config) and is_nil(from_env) ->
        raise """
        No Shippo API key found.

        Please provide one by one of the following methods:

        1. By setting the shippo application's api_key field in your application's config.

        2. By setting the SHIPPO_KEY environment variable.

        Please note, the first method takes precedence
        """
      is_nil(from_env) ->
        from_config
      true ->
        from_env
    end
  end
end
