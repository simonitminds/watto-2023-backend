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

  payload_object(:user_payload, :user)

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  mutation do
    field :signup, :user do
      arg(:username, :string)
      arg(:password, :string)

      resolve(fn %{username: username, password: password}, _ ->
        Starwebbie.Users.create_users(%{username: username, password: password})
      end)

      middleware(&build_payload/2)
    end
  end
end
