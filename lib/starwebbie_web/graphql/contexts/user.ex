defmodule StarwebbieWeb.Contexts.User do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  object :user_queries do
    @desc "fetches a list of users"
    field :users, list_of(:user) do
      middleware(StarwebbieWeb.Authentication)
      resolve(&list_users/3)
    end
  end

  payload_object(:update_user_payload, :user)
  payload_object(:signup_payload, :user_auth)

  object :user_mutations do
    @desc "updates a new user"
    field :update_user, :update_user_payload do
      middleware(StarwebbieWeb.Authentication)

      arg(:name, :string)
      arg(:username, :string)

      resolve(&update_user/3)
      middleware(&build_payload/2)
    end

    @desc "signups a new user a new user"
    field :signup, :signup_payload do
      arg(:username, :string)
      arg(:password, :string)

      resolve(&signup/3)

      middleware(&build_payload/2)
    end
  end

  defp list_users(_parent, _args, _ctx) do
    {:ok, Starwebbie.Users.list_users()}
  end

  defp update_user(_parent, args, %{context: %{current_user: current_user}} = _ctx) do
    {:ok, Starwebbie.Users.update_users(current_user, args)}
  end

  def signup(_parent, %{username: username, password: password}, _) do
    case Starwebbie.Users.create_users(%{username: username, password: password}) do
      {:ok, user} ->
        {:ok, token, _claims} = StarwebbieWeb.Guardian.encode_and_sign(user)
        {:ok, %{user: user, token: token}}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
