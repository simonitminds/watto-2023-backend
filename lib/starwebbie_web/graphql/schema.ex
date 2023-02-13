defmodule StarwebbieWeb.Schema do
  use Absinthe.Schema
  import AbsintheErrorPayload.Payload

  import_types(StarwebbieWeb.Models)
  import_types(StarwebbieWeb.Contexts.User)
  import_types(Absinthe.Type.Custom)
  import_types(AbsintheErrorPayload.ValidationMessageTypes)

  query do
    import_fields(:user_queries)

    field :hello, :string do
      arg(:name, :string)

      resolve(fn %{name: name}, _ ->
        {:ok, "Hello #{name}"}
      end)
    end
  end

  mutation do
    import_fields(:user_mutations)
  end
end
