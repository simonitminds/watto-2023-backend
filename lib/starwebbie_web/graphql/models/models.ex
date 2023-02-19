defmodule StarwebbieWeb.Models do
  alias Starwebbie.Items
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

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

    field :items, list_of(non_null(:item)) do
      resolve(dataloader(Items))
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
