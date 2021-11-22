defmodule App.ShopFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Shop` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        price: 120.5
      })
      |> App.Shop.create_product()

    product
  end
end
