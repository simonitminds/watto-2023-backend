defmodule Starwebbie.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :password, :string
    field :username, :string
    field :balance, :float, default: 100.0
    has_many :items, Starwebbie.Items.Item, foreign_key: :owner_id

    timestamps()
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:name, :username, :password, :balance])
    |> unique_constraint(:username)
    |> put_pass_hash()
    |> validate_required([:username, :password])
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password, hash_key: :password))
  end

  defp put_pass_hash(changeset), do: changeset
end
