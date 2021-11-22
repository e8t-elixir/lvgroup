alias App.Shop

seed = fn idx -> 
  now = DateTime.utc_now()
  %{
    inserted_at: now |> DateTime.add(10*idx, :second),
    description: "Description #{idx}",
    name: "Product #{idx}",
    price: idx * 6.0
  }
end

1..51 |> Enum.map(fn idx -> seed.(idx) |> Shop.seed_product() end)


