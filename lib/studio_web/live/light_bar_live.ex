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
