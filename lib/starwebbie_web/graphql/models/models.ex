defmodule StarwebbieWeb.Models do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  object :user do
    field :id, non_null(:id)
    field :name, :string
    field :username, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :type do
    field :id, non_null(:id)
    field :name, :string

    field :items, list_of(:item) do
      resolve(fn type, _args, _context ->
        {:ok, Starwebbie.Items.list_items_by_type_id(type.id)}
      end)
    end

    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :model do
    field :id, non_null(:id)
    field :name, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :user_auth do
    field :token, :string
    field :user, :user
  end
end
