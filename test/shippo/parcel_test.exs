defmodule Shippo.ParcelTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  alias Shippo.Parcel

  @valid_params %{
    length: 5,
    width: 4,
    height: 3,
    distance_unit: "in",
    weight: 2,
    mass_unit: "lb"
  }

  @invalid_params %{}

  test "create with valid params returns {:ok, parcel}" do
    use_cassette "parcel_create_valid" do
      {:ok, parcel} = Parcel.create(@valid_params)

      assert parcel["length"] == to_string(@valid_params.length)
      assert parcel["width"] == to_string(@valid_params.width)
      assert parcel["height"] == to_string(@valid_params.height)
      assert parcel["distance_unit"] == to_string(@valid_params.distance_unit)
      assert parcel["weight"] == to_string(@valid_params.weight)
      assert parcel["mass_unit"] == to_string(@valid_params.mass_unit)
    end
  end

  test "create with invalid params returns {:error, 400, body}" do
    use_cassette "parcel_create_invalid" do
      {:error, 400, body} = Parcel.create(@invalid_params)

      assert Map.has_key?(body, "mass_unit")
    end
  end

  test "get existing parcel returns {:ok, parcel}" do
    use_cassette "parcel_get_existing" do
      {:ok, parcel} = Parcel.create(@valid_params)
      {:ok, retrieved} = Parcel.get(parcel["object_id"])

      assert Float.parse(parcel["length"]) == Float.parse(retrieved["length"])
      assert Float.parse(parcel["width"]) == Float.parse(retrieved["width"])
      assert Float.parse(parcel["height"]) == Float.parse(retrieved["height"])
      assert parcel["distance_unit"] == retrieved["distance_unit"]
      assert Float.parse(parcel["weight"]) == Float.parse(retrieved["weight"])
      assert parcel["mass_unit"] == retrieved["mass_unit"]
    end
  end

  test "get non-existing parcel returns {:error, 404, body}" do
    use_cassette "parcel_get_nonexisting" do
      {:error, 404, reason} = Parcel.get("non-existing-parcel")
      assert reason =~ "Not Found"
    end
  end

  test "list returns most recent parcels" do
    use_cassette "parcel_list_returns_recent" do
      {:ok, parcel} = Parcel.create(@valid_params)
      {:ok, list} = Parcel.list()

      assert Enum.any?(list, fn p ->
               p["object_id"] == parcel["object_id"]
             end)
    end
  end
end
