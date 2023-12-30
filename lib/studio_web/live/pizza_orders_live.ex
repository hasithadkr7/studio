defmodule StudioWeb.PizzaOrdersLive do
  use StudioWeb, :live_view

  alias Studio.PizzaOrders
  import Number.Currency

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [pizza_orders: []]}
  end

  def handle_params(params, _uri, socket) do
    sort_by = valid_sort_by(params)
    sort_order = valid_sort_order(params)

    options = %{
      sort_by: sort_by,
      sort_order: sort_order
    }

    donations = PizzaOrders.list_pizza_orders(options)

    socket =
      assign(socket,
        pizza_orders: donations,
        options: options
      )

    {:noreply, socket}
  end

  attr :sort_by, :atom, required: true
  attr :options, :map, required: true
  slot :inner_block, required: true

  def sort_link(assigns) do
    ~H"""
    <.link patch={
      ~p"/pizza-orders?#{%{sort_by: @sort_by, sort_order: next_sort_order(@options.sort_order)}}"
    }>
      <%= render_slot(@inner_block) %>
      <%= sort_indicator(@sort_by, @options) %>
    </.link>
    """
  end

  defp next_sort_order(:asc) do
    :desc
  end

  defp next_sort_order(:desc) do
    :asc
  end

  defp sort_indicator(column, %{sort_by: sort_by, sort_order: sort_order})
       when column == sort_by do
    case sort_order do
      :asc -> "👆"
      :desc -> "👇"
    end
  end

  defp sort_indicator(_column, _) do
    "👆"
  end

  defp valid_sort_by(%{"sort_by" => sort_by})
       when sort_by in ~w(size style topping_1 topping_2 price) do
    to_atom(sort_by)
  end

  defp valid_sort_by(_params), do: :size

  defp valid_sort_order(%{"sort_order" => sort_order})
       when sort_order in ~w(asc desc) do
    to_atom(sort_order)
  end

  defp valid_sort_order(_params), do: :asc

  defp to_atom(str) when is_binary(str) do
    try do
      String.to_existing_atom(str)
    rescue
      _ ->
        String.to_atom(str)
    end
  end
end
