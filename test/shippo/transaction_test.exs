defmodule Shippo.TransactionTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  alias Shippo.Transaction

  @valid_shipment_params %{
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

  # TODO: make this test pass when carrier accounts are implemented
  test "create with valid shipment returns {:ok, transaction}" do
    use_cassette "transaction_create_valid_with_shipment" do
      {:ok, transaction} =
        Transaction.create(%{
          shipment: @valid_shipment_params,
          servicelevel_token: "usps_priority",
          carrier_account: "phony_test"
        })

      assert transaction["status"] == "SUCCESS"
    end
  end

  test "create with rate id returns {:ok, transaction}" do
    use_cassette "transaction_create_valid_with_rate" do
      {:ok, %{"rates" => rates}} = Shippo.Shipment.create(@valid_shipment_params)

      {:ok, transaction} = Transaction.create(List.first(rates)["object_id"], %{async: false})
      assert transaction["rate"] == List.first(rates)["object_id"]
    end
  end
end
