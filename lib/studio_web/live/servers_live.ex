defmodule StudioWeb.ServersLive do
  use StudioWeb, :live_view

  alias Studio.Servers
  alias Studio.Servers.Server

  def mount(_params, _session, socket) do
    servers = Servers.list_servers()

    changeset = Servers.change_server(%Server{})

    socket =
      assign(socket,
        servers: servers,
        selected_server: hd(servers),
        coffees: 0,
        form: to_form(changeset)
      )

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    IO.inspect(self(), label: "HANDLE PARAMS ID=#{id}")
    server = Servers.get_server!(id)

    {:noreply,
     assign(socket,
       selected_server: server,
       page_title: "What's up #{server.name}"
     )}
  end

  def handle_params(_params, _uri, socket) do
    IO.inspect(self(), label: "HANDLE PARAMS CATCH-ALL")

    {:noreply,
     assign(socket,
       selected_server: nil
     )}
  end

  def render(assigns) do
    IO.inspect(self(), label: "RENDER")

    ~H"""
    <h1>Servers</h1>
    <div id="servers">
      <div class="sidebar">
        <div class="nav">
          <.link
            :for={server <- @servers}
            patch={~p"/servers/#{server}"}
            class={if server == @selected_server, do: "selected"}
          >
            <span class={server.status}></span>
            <%= server.name %>
          </.link>
        </div>
        <div class="coffees">
          <button phx-click="drink">
            <img src="/images/coffee.svg" />
            <%= @coffees %>
          </button>
        </div>
      </div>

      <div class="main">
        <div class="wrapper">
          <.form for={@form} phx-submit="save">
            <div class="field">
              <.input field={@form[:name]} placeholder="Name" autocomplete="off" />
            </div>
            <div class="field">
              <.input field={@form[:framework]} placeholder="Framework" autocomplete="off" />
            </div>
            <div class="field">
              <.input field={@form[:size]} placeholder="Size (MB)" type="number" />
            </div>
            <div class="field">
              <.input
                field={@form[:last_commit_message]}
                placeholder="Last commit message"
                autocomplete="off"
              />
            </div>
            <div class="field">
              <.button phx-disable-with="Saving...">Create</.button>
            </div>
          </.form>
          <div class="server">
            <.server :if={@selected_server} server={@selected_server} />
          </div>
          <div class="links">
            <.link navigate={~p"/light"}>
              Adjust Lights
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def server(assigns) do
    assigns = assign(assigns, :selected_server, assigns.server)

    ~H"""
    <div class="header">
      <h2><%= @selected_server.name %></h2>
      <span class={@selected_server.status}>
        <%= @selected_server.status %>
      </span>
    </div>
    <div class="body">
      <div class="row">
        <span>
          <%= @selected_server.deploy_count %> deploys
        </span>
        <span>
          <%= @selected_server.size %> MB
        </span>
        <span>
          <%= @selected_server.framework %>
        </span>
      </div>
      <h3>Last Commit Message:</h3>
      <blockquote>
        <%= @selected_server.last_commit_message %>
      </blockquote>
    </div>
    """
  end

  def handle_event("drink", _, socket) do
    IO.inspect(self(), label: "DRINK")
    {:noreply, update(socket, :coffees, &(&1 + 1))}
  end

  def handle_event("save", %{"server" => server_params}, socket) do
    case Servers.create_server(server_params) do
      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}

      {:ok, server} ->
        socket =
          update(
            socket,
            :servers,
            fn servers -> [server | servers] end
          )

        changeset = Servers.change_server(%Server{})

        socket =
          assign(socket,
            form: to_form(changeset)
          )

        {:noreply, socket}
    end
  end
end
