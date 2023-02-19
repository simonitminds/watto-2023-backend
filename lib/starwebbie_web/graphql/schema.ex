defmodule StarwebbieWeb.Schema do
  use Absinthe.Schema
  alias Starwebbie.{Items, Users}

  import_types(StarwebbieWeb.Models)
  import_types(StarwebbieWeb.Contexts.User)
  import_types(StarwebbieWeb.Contexts.Auth)
  import_types(StarwebbieWeb.Contexts.Items)
  import_types(Absinthe.Type.Custom)
  import_types(AbsintheErrorPayload.ValidationMessageTypes)

  query do
    import_fields(:user_queries)
    import_fields(:item_queries)
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:item_mutations)
    import_fields(:auth_mutations)
  end

  subscription do
    field :marketplace, list_of(non_null(:item)) do
      arg(:user_id, non_null(:id))

      config(fn %{user_id: user_id}, _info ->
        {:ok, topic: "marketplace:#{user_id}"}
      end)
    end
  end

  @impl true
  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Users, Users.data())
      |> Dataloader.add_source(Items, Items.data())

    Map.put(ctx, :loader, loader)
  end

  @impl true
  def plugins() do
    [
      Absinthe.Middleware.Dataloader
    ] ++ Absinthe.Plugin.defaults()
  end
end
