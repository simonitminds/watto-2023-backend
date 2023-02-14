defmodule Starwebbie.Items.Model do
  use Ecto.Schema
  import Ecto.Changeset

  schema "models" do
    field :index_price, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [:name, :index_price])
    |> validate_required([:name, :index_price])
  end
end
