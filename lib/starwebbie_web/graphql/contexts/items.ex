defmodule StarwebbieWeb.Contexts.Items do
  use Absinthe.Schema.Notation

  object :item do
    field :id, non_null(:id)
    field :name, :string
    field :type, :type
    field :model, :model

    field :price, :float do
      resolve(&price/3)
    end

    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :item_queries do
    field :items, list_of(:item) do
      resolve(&items/3)
    end

    field :item, :item do
      arg(:id, non_null(:id))
      resolve(&item/3)
    end

    def items(_parent, _args, _context) do
      {:ok, Starwebbie.Items.list_items()}
    end

    def item(_, args, _) do
      case Starwebbie.Items.get_item(args.id) do
        nil -> {:error, "Item not found"}
        item -> {:ok, item}
      end
    end

    def price(item, _args, _context) do
      dbg(item)
      {:ok, item.model.index_price * item.type.multiplier}
    end
  end
end
