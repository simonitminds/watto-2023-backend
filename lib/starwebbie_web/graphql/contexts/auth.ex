defmodule StarwebbieWeb.Contexts.Auth do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  payload_object(:auth_payload, :user_auth)

  object :auth_mutations do
    @desc "signups a new user a new user"
    field :signup, :auth_payload do
      arg(:username, :string)
      arg(:password, :string)

      resolve(&signup/3)

      middleware(&build_payload/2)
    end

    @desc "logins a user"
    field :login, :auth_payload do
      arg(:username, :string)
      arg(:password, :string)

      resolve(&login/3)

      middleware(&build_payload/2)
    end
  end

  def login(_parent, %{username: username, password: password}, _) do
    case Starwebbie.Users.authenticate_username(username, password) do
      {:ok, user} ->
        {:ok, token, _claims} = StarwebbieWeb.Guardian.encode_and_sign(user)
        {:ok, %{user: user, token: token}}

      {:error, _} ->
        {:error, "Invalid login credentials"}
    end
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
