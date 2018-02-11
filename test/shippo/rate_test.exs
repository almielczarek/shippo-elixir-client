defmodule Shippo.RateTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  alias Shippo.Rate
  alias Shippo.Shipment

  test "get with non-existing id returns {:error, 404}" do
    use_cassette "rate_get_nonexisting" do
      {:error, 404, _} = Rate.get("asdf")
    end
  end

  test "get with existing id returns {:ok, rate}" do
    use_cassette "rate_get_existing" do
      params = %{
        address_from: %{
          name: "Mrs. Hippo",
          street1: "215 Clayton St.",
          city: "San Francisco",
          state: "CA",
          zip: "94117",
          country: "US"
        },
        address_to: %{
          name: "Mr. Hippo",
          street1: "965 Mission St #572",
          city: "San Francisco",
          state: "CA",
          zip: "94103",
          country: "US"
        },
        parcels: [
          %{
            length: 4,
            width: 4,
            height: 4,
            distance_unit: "in",
            weight: 3,
            mass_unit: "oz"
          }
        ],
        async: false
      }

      {:ok, shipment} = Shipment.create(params)

      rate_id = List.first(shipment["rates"])["object_id"]
      {:ok, _} = Rate.get(rate_id)
    end
  end
end
