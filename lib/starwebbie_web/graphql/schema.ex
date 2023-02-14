defmodule StarwebbieWeb.Schema do
  use Absinthe.Schema

  import_types(StarwebbieWeb.Models)
  import_types(StarwebbieWeb.Contexts.User)
  import_types(StarwebbieWeb.Contexts.Auth)
  import_types(Absinthe.Type.Custom)
  import_types(AbsintheErrorPayload.ValidationMessageTypes)

  query do
    import_fields(:user_queries)
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:auth_mutations)
  end
end
