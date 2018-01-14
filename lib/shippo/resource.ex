defmodule Shippo.Resource do
  @callback endpoint :: String.t

  defmacro __using__(_opts) do
    quote do
      @behaviour Shippo.Resource

      def get(id) do
        Shippo.get(endpoint() <> "/" <> id)
        |> Shippo.process_response
      end

      def create(params) do
        Shippo.post(endpoint(), params)
        |> Shippo.process_response
      end

      def list do
        case Shippo.get(endpoint()) do
          %{status: 200, body: %{"results" => results}} ->
            {:ok, results}
          response ->
            {:error, response.status, response.body}
        end
      end

      defoverridable [get: 1, create: 1, list: 0]
    end
  end
end
