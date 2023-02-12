defmodule Starwebbie.Users do
  @moduledoc """
  The User context.
  """

  import Ecto.Query, warn: false
  alias Starwebbie.Repo

  alias Starwebbie.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single users.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_users!(123)
      %User{}

      iex> get_users!(456)
      ** (Ecto.NoResultsError)

  """
  def get_users!(id), do: Repo.get!(User, id)

  @doc """
  Creates a users.

  ## Examples

      iex> create_users(%{field: value})
      {:ok, %User{}}

      iex> create_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_users(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def check_auth(username, password) do
    user =
      from(u in User, where: u.username == ^username)
      |> Repo.one()

    case Argon2.verify_pass(password, user.password) do
      true -> user
      false -> nil
    end
  end

  @doc """
  Updates a users.

  ## Examples

      iex> update_users(users, %{field: new_value})
      {:ok, %User{}}

      iex> update_users(users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_users(%User{} = users, attrs) do
    users
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a users.

  ## Examples

      iex> delete_users(users)
      {:ok, %User{}}

      iex> delete_users(users)
      {:error, %Ecto.Changeset{}}

  """
  def delete_users(%User{} = users) do
    Repo.delete(users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking users changes.

  ## Examples

      iex> change_users(users)
      %Ecto.Changeset{data: %User{}}

  """
  def change_users(%User{} = users, attrs \\ %{}) do
    User.changeset(users, attrs)
  end
end
