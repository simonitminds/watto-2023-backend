defmodule Starwebbie.UserFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Starwebbie.User` context.
  """

  @doc """
  Generate a users.
  """
  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> Enum.into(%{
        name: "some name",
        password: "some password",
        username: "some username"
      })
      |> Starwebbie.User.create_users()

    users
  end
end
