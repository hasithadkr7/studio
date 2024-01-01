defmodule Studio.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset

  schema "servers" do
    field :name, :string
    field :status, :string, default: "down"
    field :deploy_count, :integer, default: 0
    field :size, :float
    field :framework, :string
    field :last_commit_message, :string

    timestamps()
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:name, :status, :deploy_count, :size, :framework, :last_commit_message])
    |> validate_required([:name, :size, :framework, :last_commit_message])
    |> validate_number(:deploy_count, greater_than: 0, less_than: 10)
    |> validate_inclusion(:status, ["up", "down"])
    |> validate_number(:size, greater_than: 0)
  end
end
