defmodule StudioWeb.VehiclesLive do
  use StudioWeb, :live_view

  alias Studio.Vehicles
  alias StudioWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        make_model: "",
        loading: false,
        vehicles: [],
        matches: %{}
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>🚙 Find a Vehicle 🚘</h1>
    <div id="vehicles">
      <form phx-submit="search" phx-change="suggest">
        <input
          type="text"
          name="query"
          value={@make_model}
          placeholder="Make or model"
          autofocus
          autocomplete="off"
          list="matches"
          phx-debounce="1000"
        />

        <button>
          <img src="/images/search.svg" />
        </button>
      </form>

      <datalist id="matches">
        <option :for={name <- @matches}>
          <%= name %>
        </option>
      </datalist>

      <CustomComponents.loading_indicator loading={@loading} />

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

  def handle_event("suggest", %{"query" => prefix}, socket) do
    IO.inspect(self(), label: "SUGGEST")

    socket =
      assign(socket,
        matches: Vehicles.suggest(prefix)
      )

    {:noreply, socket}
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
