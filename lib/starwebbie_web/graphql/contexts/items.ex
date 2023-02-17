defmodule StarwebbieWeb.Contexts.Items do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  object :item do
    field :id, non_null(:id)
    field :name, :string

    field :type, :type do
      resolve(fn item, _args, _context ->
        {:ok, Starwebbie.Items.get_type(item.type_id)}
      end)
    end

    field :model, :model do
      resolve(fn item, _args, _context ->
        {:ok, Starwebbie.Items.get_model(item.model_id)}
      end)
    end

    field :price, non_null(:float) do
      resolve(&price/3)
    end

    field :owner, :user do
      resolve(fn item, _args, _context ->
        {:ok, Starwebbie.Users.get_users!(item.owner_id)}
      end)
    end

    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  object :item_queries do
    field :item_list, list_of(non_null(:item)) do
      middleware(StarwebbieWeb.Authentication)
      resolve(&items/3)
    end

    field :item_list_by_user_id, list_of(non_null(:item)) do
      arg(:user_id, non_null(:id))
      middleware(StarwebbieWeb.Authentication)
      resolve(&items/3)
    end

    field :item_get, :item do
      arg(:id, non_null(:id))
      middleware(StarwebbieWeb.Authentication)
      resolve(&item/3)
    end

    field :model_list, list_of(non_null(:model)) do
      middleware(StarwebbieWeb.Authentication)
      resolve(&models/3)
    end

    field :model_get, :model do
      arg(:id, non_null(:id))
      middleware(StarwebbieWeb.Authentication)
      resolve(&model/3)
    end

    field :type_list, list_of(non_null(:type)) do
      middleware(StarwebbieWeb.Authentication)
      resolve(&types/3)
    end

    field :type_get, :type do
      arg(:id, non_null(:id))
      middleware(StarwebbieWeb.Authentication)
      resolve(&type/3)
    end
  end

  payload_object(:item_payload, :item)
  payload_object(:model_payload, :model)
  payload_object(:type_payload, :type)

  object :item_mutations do
    field :item_create, :item_payload do
      arg(:name, non_null(:string))
      arg(:type_id, non_null(:id))
      arg(:owner_id, non_null(:id))
      arg(:model_id, non_null(:id))
      middleware(StarwebbieWeb.Authentication)
      resolve(&create_item/3)
      middleware(&build_payload/2)
    end

    field :buy_item, :item_payload do
      arg(:item_id, non_null(:id))
      middleware(StarwebbieWeb.Authentication)
      resolve(&buy_item/3)
      middleware(&build_payload/2)
    end

    field :sell_item, :item_payload do
      arg(:item_id, non_null(:id))
      middleware(StarwebbieWeb.Authentication)
      resolve(&sell_item/3)
      middleware(&build_payload/2)
    end

    field :item_update, :item_payload do
      arg(:name, non_null(:string))
      arg(:id, non_null(:id))
      arg(:type_id, non_null(:id))
      arg(:model_id, non_null(:id))
      middleware(StarwebbieWeb.Authentication)
      resolve(&update_item/3)
      middleware(&build_payload/2)
    end

    field :model_create, :model_payload do
      arg(:name, non_null(:string))
      arg(:multiplier, non_null(:integer))
      middleware(StarwebbieWeb.Authentication)
      resolve(&create_model/3)
      middleware(&build_payload/2)
    end

    field :model_update, :model_payload do
      arg(:id, non_null(:id))
      arg(:name, non_null(:string))
      arg(:multiplier, non_null(:integer))

      middleware(StarwebbieWeb.Authentication)
      resolve(&update_model/3)
      middleware(&build_payload/2)
    end

    field :type_create, :type_payload do
      arg(:name, non_null(:string))
      arg(:index_price, non_null(:integer))
      middleware(StarwebbieWeb.Authentication)
      resolve(&create_type/3)
      middleware(&build_payload/2)
    end

    field :type_update, :type_payload do
      arg(:id, non_null(:id))
      arg(:name, non_null(:string))
      arg(:index_price, non_null(:integer))
      middleware(StarwebbieWeb.Authentication)

      resolve(&update_type/3)
      middleware(&build_payload/2)
    end
  end

  def update_item(_, args, _) do
    item = Starwebbie.Items.get_item(args.id)

    case item do
      nil ->
        {:error, "Item not found"}

      item ->
        Starwebbie.Items.update_item(item, args)
    end
  end

  def buy_item(_, args, %{context: %{current_user: current_user}}) do
    case Starwebbie.Items.buy_item(args.item_id, current_user.id) do
      {:ok, data} -> {:ok, Map.get(data, :update_item)}
      e -> {:error, elem(e, 2)}
    end
  end

  def sell_item(_, args, %{context: %{current_user: current_user}}) do
    webshob_owner = Starwebbie.Users.get_users!("dark_saber_dealer")

    case Starwebbie.Items.trade_item(args.item_id, current_user.id, webshob_owner.id) do
      {:ok, data} -> {:ok, Map.get(data, :update_item)}
      e -> {:error, elem(e, 2)}
    end
  end

  def create_item(_, args, _) do
    Starwebbie.Items.create_item(args)
  end

  def update_type(_, args, _) do
    type = Starwebbie.Items.get_type(args.id)

    case type do
      nil ->
        {:error, "type not found"}

      type ->
        Starwebbie.Items.update_type(type, args)
    end
  end

  def create_type(_, args, _) do
    Starwebbie.Items.create_type(args)
  end

  def update_model(_, args, _) do
    model = Starwebbie.Items.get_model(args.id)

    case model do
      nil ->
        {:error, "model not found"}

      model ->
        Starwebbie.Items.update_model(model, args)
    end
  end

  def create_model(_, args, _) do
    Starwebbie.Items.create_model(args)
  end

  def items(_parent, %{user_id: user_id}, _context) do
    {:ok, Starwebbie.Items.list_items(user_id: user_id)}
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

  def models(_parent, _args, _context) do
    {:ok, Starwebbie.Items.list_models()}
  end

  def model(_, args, _) do
    case Starwebbie.Items.get_model(args.id) do
      nil -> {:error, "model not found"}
      model -> {:ok, model}
    end
  end

  def types(_parent, _args, _context) do
    {:ok, Starwebbie.Items.list_types()}
  end

  def type(_, args, _) do
    case Starwebbie.Items.get_type(args.id) do
      nil -> {:error, "Item not found"}
      type -> {:ok, type}
    end
  end

  def price(item, _args, _context) do
    {:ok, item.model.index_price * item.type.multiplier}
  end
end
