defmodule StarwebbieWeb.Models do
  use Absinthe.Schema.Notation

  object :user do
    field :id, non_null(:id)
    field :name, :string
    field :username, non_null(:string)
    field :balance, non_null(:float)
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :type do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :multiplier, non_null(:float)

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
    field :name, non_null(:string)
    field :index_price, non_null(:integer)
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :user_auth do
    field :token, :string
    field :user, :user
  end
end
