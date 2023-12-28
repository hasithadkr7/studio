defmodule StudioWeb.VehiclesLive do
  use StudioWeb, :live_view

  alias Studio.Vehicles

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        make_model: "",
        loading: false,
        vehicles: []
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>🚙 Find a Vehicle 🚘</h1>
    <div id="vehicles">
      <form phx-submit="search">
        <input
          type="text"
          name="query"
          value={@make_model}
          placeholder="Make or model"
          autofocus
          autocomplete="off"
        />

        <button>
          <img src="/images/search.svg" />
        </button>
      </form>

      <div :if={@loading} class="loader">Loading...</div>

      <div class="vehicles">
        <ul>
          <li :for={vehicle <- @vehicles}>
            <span class="make-model">
              <%= vehicle.make_model %>
            </span>
            <span class="color">
              <%= vehicle.color %>
            </span>
            <span class={"status #{vehicle.status}"}>
              <%= vehicle.status %>
            </span>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("search", %{"query" => make_or_model}, socket) do
    IO.inspect(self(), label: "SEARCH")
    send(self(), {:search_car, make_or_model})

    socket =
      assign(socket,
        make_or_model: make_or_model,
        loading: true,
        vehicles: []
      )

    {:noreply, socket}
  end

  def handle_info({:search_car, make_or_model}, socket) do
    IO.inspect(self(), label: "SEARCH_CAR")

    socket =
      assign(socket,
        make_or_model: make_or_model,
        loading: false,
        vehicles: Vehicles.search(make_or_model)
      )

    {:noreply, socket}
  end
end
