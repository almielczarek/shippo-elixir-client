defmodule Shippo.AddressTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  alias Shippo.Address

  @valid_params %{
    name: "Mrs. Hippo",
    street1: "215 Clayton St.",
    city: "San Francisco",
    state: "CA",
    zip: "94117",
    country: "US"
  }

  @invalid_params %{country: "US"}

  test "create with valid params and `validate: true` returns {:ok, address}" do
    use_cassette "address_create_valid" do
      {:ok, address} = Address.create(Address.mark_for_validation(@valid_params))
      assert address["name"] == @valid_params.name
    end
  end

  test "create without country code returns {:error, 400, msg}" do
    use_cassette "address_create_no_country" do
      {:error, 400, %{"country" => _}} = Address.create(Map.delete(@valid_params, :country))
    end
  end

  def has_error?(list, code) do
    Enum.any?(list, fn error -> code == error["code"] end)
  end

  test "create with invalid params and `validate: true` returns {:invalid, list}" do
    use_cassette "address_create_invalid" do
      {:invalid, list} = Address.create(Address.mark_for_validation(@invalid_params))
      assert has_error?(list, "Invalid State")
    end
  end

  test "get with existing address returns {:ok, address}" do
    use_cassette "address_get_existing" do
      {:ok, address} = Address.create(@valid_params)
      {:ok, retrieved} = Address.get(address["object_id"])

      assert address["name"] == retrieved["name"]
      assert address["street1"] == retrieved["street1"]
      assert address["city"] == retrieved["city"]
      assert address["state"] == retrieved["state"]
      assert address["zip"] == retrieved["zip"]
      assert address["country"] == retrieved["country"]
    end
  end

  test "get with non-existing address returns {:error, 404, msg}" do
    use_cassette "address_get_nonexisting" do
      {:error, 404, _} = Address.get("non-existing-id")
    end
  end

  test "mark_for_validation fails on non-map" do
    assert_raise ArgumentError, fn ->
      Address.mark_for_validation("string")
    end
  end

  test "validate existing address with valid params" do
    use_cassette "address_validate_valid_existing" do
      {:ok, address} = Address.create(@valid_params)
      {:ok, _} = Address.validate(address["object_id"])
    end
  end

  test "validate existing address with invalid params" do
    use_cassette "address_validate_invalid_existing" do
      {:ok, address} = Address.create(@invalid_params)
      {:invalid, messages} = Address.validate(address["object_id"])

      assert has_error?(messages, "Invalid State")
    end
  end

  test "list retrieves previously created address" do
    use_cassette "address_list" do
      {:ok, address} = Address.create(@valid_params)
      {:ok, list} = Address.list()

      assert Enum.any?(list, fn a ->
               a["name"] == address["name"] and a["street1"] == address["street1"]
             end)
    end
  end
end
