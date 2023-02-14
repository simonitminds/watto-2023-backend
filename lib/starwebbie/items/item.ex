defmodule Starwebbie.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    belongs_to :owner, Starwebbie.Users.User
    belongs_to :model, Starwebbie.Items.Model
    belongs_to :type, Starwebbie.Items.Type

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :owner_id, :model_id, :type_id])
    |> validate_required([:name, :owner_id, :model_id, :type_id])
  end
end
