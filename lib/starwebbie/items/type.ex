defmodule Starwebbie.Items.Type do
  use Ecto.Schema
  import Ecto.Changeset

  schema "types" do
    field :multiplier, :float
    field :name, :string
    has_many :items, Starwebbie.Items.Item

    timestamps()
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name, :multiplier])
    |> validate_required([:name, :multiplier])
  end
end
