defmodule StudioWeb.VolunteersLive do
  use StudioWeb, :live_view

  alias Studio.Volunteers
  alias Studio.Volunteers.Volunteer

  def mount(_params, _session, socket) do
    volunteers = Volunteers.list_volunteers()

    changeset = Volunteers.change_volunteer(%Volunteer{})

    socket =
      assign(socket,
        volunteers: volunteers,
        form: to_form(changeset)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Volunteer Check-In</h1>
    <div id="volunteer-checkin">
      <.form for={@form} phx-submit="save">
        <.input field={@form[:name]} placeholder="Name" autocomplete="off" />
        <.input field={@form[:phone]} placeholder="Phone number" type="tel" autocomplete="off" />
        <.button phx-disable-with="Saving...">Check In</.button>
      </.form>
      <.flash_group flash={@flash} />
      <div :for={volunteer <- @volunteers} class={"volunteer #{if volunteer.checked_out, do: "out"}"}>
        <div class="name">
          <%= volunteer.name %>
        </div>
        <div class="phone">
          <%= volunteer.phone %>
        </div>
        <div class="status">
          <button>
            <%= if volunteer.checked_out, do: "Check In", else: "Check Out" %>
          </button>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("save", %{"volunteer" => volunteer_params}, socket) do
    case Volunteers.create_volunteer(volunteer_params) do
      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}

      {:ok, volunteer} ->
        socket =
          update(
            socket,
            :volunteers,
            fn volunteers -> [volunteer | volunteers] end
          )

        changeset = Volunteers.change_volunteer(%Volunteer{})

        socket =
          assign(socket,
            form: to_form(changeset)
          )

        socket = put_flash(socket, :info, "Volunteer successfully checked in!")

        {:noreply, socket}
    end
  end
end
