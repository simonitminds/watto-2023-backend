defmodule StarwebbieWeb.Schema do
  use Absinthe.Schema
  import AbsintheErrorPayload.Payload

  import_types(StarwebbieWeb.Models)
  import_types(Absinthe.Type.Custom)
  import_types(AbsintheErrorPayload.ValidationMessageTypes)

  query do
    field :hello, :string do
      arg(:name, :string)

      resolve(fn %{name: name}, _ ->
        {:ok, "Hello #{name}"}
      end)
    end
  end

  payload_object(:signup_payload, :user_auth)

  mutation do
    field :signup, :signup_payload do
      arg(:username, :string)
      arg(:password, :string)

      resolve(fn %{username: username, password: password}, _ ->
        case Starwebbie.Users.create_users(%{username: username, password: password}) do
          {:ok, user} ->
            {:ok, token, _claims} = StarwebbieWeb.Guardian.encode_and_sign(user)
            {:ok, %{user: user, token: token}}

          {:error, changeset} ->
            {:error, changeset}
        end
      end)

      middleware(&build_payload/2)
    end
  end
end
