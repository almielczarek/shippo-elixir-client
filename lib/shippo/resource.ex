defmodule Shippo.Resource do
  @callback endpoint :: String.t

  @defaults [get: 1, create: 1, list: 0]

  defp methods(opts) do
    only = Keyword.get(opts, :only)
    if only do
      only
    else
      except = Keyword.get(opts, :except, [])
      Enum.reduce(except, @defaults, fn {m, _}, acc ->
        Keyword.delete(acc, m)
      end)
    end
  end

  defmacro __using__(opts) do
    methods = methods(opts)

    quote do
      @behaviour Shippo.Resource

      if unquote(methods[:get]) do
        def get(id) do
          Shippo.get(endpoint() <> "/" <> id)
          |> Shippo.process_response
        end
      end

      if unquote(methods[:create]) do
        def create(params) do
          Shippo.post(endpoint(), params)
          |> Shippo.process_response
        end
      end

      if unquote(methods[:list]) do
        def list do
          case Shippo.get(endpoint()) do
            %{status: 200, body: %{"results" => results}} ->
              {:ok, results}
            response ->
              {:error, response.status, response.body}
          end
        end
      end

      defoverridable unquote(methods)
    end
  end
end
