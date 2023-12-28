defmodule StudioWeb.SandboxLive do
  use StudioWeb, :live_view

  import Number.Currency
  alias Studio.Sandbox

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        length: "0",
        width: "0",
        depth: "0",
        weight: 0.0,
        price: nil
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Build A Sandbox</h1>
    <div id="sandbox">
      <form phx-change="calculate" phx-submit="get-quote">
        <div class="fields">
          <div>
            <label for="length">Length</label>
            <div class="input">
              <input type="number" name="length" value={@length} />
              <span class="unit">feet</span>
            </div>
          </div>
          <div>
            <label for="width">Width</label>
            <div class="input">
              <input type="number" name="width" value={@width} />
              <span class="unit">feet</span>
            </div>
          </div>
          <div>
            <label for="depth">Depth</label>
            <div class="input">
              <input type="number" name="depth" value={@depth} />
              <span class="unit">inches</span>
            </div>
          </div>
        </div>
        <div class="weight">
          You need <%= @weight %> pounds of sand 🏝
        </div>
        <button type="submit">
          Get A Quote
        </button>
      </form>
      <div :if={@price} class="quote">
        Get your personal beach today for only <%= number_to_currency(@price) %>
      </div>
    </div>
    """
  end

  def handle_event("calculate", %{"length" => l, "width" => w, "depth" => d}, socket) do
    IO.inspect(self(), label: "CALCULATE")
    weight = Sandbox.calculate_weight(l, w, d)

    socket =
      assign(socket,
        length: l,
        width: w,
        depth: d,
        weight: weight,
        price: nil
      )

    {:noreply, socket}
  end

  def handle_event("get-quote", _params, socket) do
    IO.inspect(self(), label: "GET QUOTE")
    price = Sandbox.calculate_price(socket.assigns.weight)

    socket =
      assign(socket,
        price: price
      )

    {:noreply, socket}
  end
end
