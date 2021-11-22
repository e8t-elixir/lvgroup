defmodule AppWeb.ProductLive.Index do
  use AppWeb, :live_view

  alias App.Shop
  alias App.Shop.Product

  @impl true
  def mount(_params, _session, socket) do
    # {:ok, assign(socket, :products, list_products())}

    # products = if connected(socket), do: Shop.paginate_products().entries, else []
    # {:ok, assign(socket, :products, products)}

    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } =
      if connected?(socket) do
        Shop.paginate_products()
      else
        %Scrivener.Page{}
      end

    assigns = [
      products: entries,
      # why not just: page_number,
      page_number: page_number || 0,
      page_size: page_size || 0,
      total_entries: total_entries || 0,
      total_pages: total_pages || 0
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Shop.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id, "page" => page}, socket) do
    product = Shop.get_product!(id)
    {:ok, _} = Shop.delete_product(product)

    {:noreply, assign(socket, list_by_page(page))}
  end

  # 翻页
  # def handle_event("nav", %{ page})
  def handle_event("nav", %{"page" => page}, socket) do
    IO.inspect(page)
    {:noreply, assign(socket, list_by_page(page))}
  end

  # defp list_products do
  #   Shop.list_products()
  # end

  defp list_by_page(page) do
    with page_number <- page |> String.to_integer() do
      %{products: Shop.paginate_products(page: page_number), page_number: page_number}
    end
  end
end
