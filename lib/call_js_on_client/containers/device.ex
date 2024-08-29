defmodule CallJSonClient.Containers.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
