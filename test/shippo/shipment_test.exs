defmodule Shippo.ShipmentTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  alias Shippo.Shipment

  @valid_params %{
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
    ]
  }

  @invalid_params %{}

  test "create with valid params returns {:ok, shipment}" do
    use_cassette "shipment_create_valid" do
      {:ok, shipment} = Shipment.create(@valid_params)

      assert shipment["address_from"]["name"] == @valid_params.address_from.name
    end
  end

  test "create with invalid params returns {:error, 400, body}" do
    use_cassette "shipment_create_invalid" do
      {:error, 400, body} = Shipment.create(@invalid_params)

      assert Map.has_key?(body, "parcels")
      assert Map.has_key?(body, "address_from")
      assert Map.has_key?(body, "address_to")
    end
  end

  test "get existing shipment returns {:ok, shipment}" do
    use_cassette "shipment_get_existing" do
      {:ok, shipment} = Shipment.create(@valid_params)
      {:ok, retrieved} = Shipment.get(shipment["object_id"])

      assert shipment["object_id"] == retrieved["object_id"]
    end
  end

  test "get non-existing shipment returns {:error, 404, body}" do
    use_cassette "shipment_get_nonexisting" do
      {:error, 404, reason} = Shipment.get("non-existing-shipment")
      assert reason =~ "Not Found"
    end
  end

  test "list returns most recent shipments" do
    use_cassette "shipment_list_returns_recent" do
      {:ok, shipment} = Shipment.create(@valid_params)
      {:ok, list} = Shipment.list()

      assert Enum.any?(list, fn p ->
               p["object_id"] == shipment["object_id"]
             end)
    end
  end
end
