defmodule StarwebbieWeb.Schema do
  use Absinthe.Schema

  query do
    field :hello, :string do
      arg(:name, :string)

      resolve(fn %{name: name}, _ ->
        {:ok, "Hello #{name}"}
      end)
    end
  end
end
