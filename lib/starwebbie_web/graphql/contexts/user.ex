defmodule StarwebbieWeb.Contexts.User do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  object :user_queries do
    @desc "fetches a list of users"
    field :users, list_of(:user) do
      middleware(StarwebbieWeb.Authentication)
      resolve(&list_users/3)
    end

    field :me, :user do
      middleware(StarwebbieWeb.Authentication)
      resolve(&me/3)
    end
  end

  payload_object(:update_user_payload, :user)

  object :user_mutations do
    @desc "updates a new user"
    field :update_user, :update_user_payload do
      middleware(StarwebbieWeb.Authentication)

      arg(:name, :string)
      arg(:username, :string)

      resolve(&update_user/3)
      middleware(&build_payload/2)
    end
  end

  defp me(_parent, _args, %{context: %{current_user: current_user}} = _ctx) do
    {:ok, current_user}
  end

  defp list_users(_parent, _args, _ctx) do
    {:ok, Starwebbie.Users.list_users()}
  end

  defp update_user(_parent, args, %{context: %{current_user: current_user}} = _ctx) do
    {:ok, Starwebbie.Users.update_users(current_user, args)}
  end
end
