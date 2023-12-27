defmodule StudioWeb.LightBarLive do
  use StudioWeb, :live_view

  def mount(_params, _session, socket) do
    IO.inspect(self(), label: "MOUNT")

    socket =
      assign(socket,
        brightness: 10,
        temp: "3000"
      )

    {:ok, socket}
  end

  def render(assigns) do
    IO.inspect(self(), label: "RENDER")

    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%; background: #{temp_color(@temp)}"}>
          <%= @brightness %>%
        </span>
      </div>
      <form phx-change="change-temp">
        <%= for temp <- ["3000", "4000", "5000"] do %>
          <input type="radio" id={temp} name="temp" value={temp} checked={temp == @temp} />
          <label for={temp}><%= temp %></label>
        <% end %>
      </form>
      <form phx-change="move">
        <input type="range" min="0" max="100" name="brightness" value={@brightness} />
      </form>
    </div>
    """
  end

  def handle_event("move", %{"brightness" => brightness}, socket) do
    IO.inspect(self(), label: "MOVE")

    socket =
      assign(socket,
        brightness: String.to_integer(brightness)
      )

    {:noreply, socket}
  end

  def handle_event("change-temp", params, socket) do
    IO.inspect(self(), label: "MOVE")
    IO.inspect(params)
    %{"temp" => temp} = params

    socket =
      assign(socket,
        temp: temp
      )

    {:noreply, socket}
  end

  defp temp_color("3000"), do: "#F1C40D"
  defp temp_color("4000"), do: "#FEFF66"
  defp temp_color("5000"), do: "#99CCFF"
end
