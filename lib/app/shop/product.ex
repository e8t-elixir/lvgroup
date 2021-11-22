defmodule App.Shop.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :price, :float

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price])
    |> validate_required([:name, :description, :price])
  end

  def inserted_at_changeset(product, attrs) do
    product
    |> cast(attrs, [:inserted_at])
  end
end
