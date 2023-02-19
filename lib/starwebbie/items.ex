defmodule Starwebbie.Items do
  @moduledoc """
  The Items context.
  """

  import Ecto.Query, warn: false
  alias Starwebbie.Repo

  alias Starwebbie.Items.Model

  @doc """
  Returns the list of models.

  ## Examples

      iex> list_models()
      [%Model{}, ...]

  """
  def list_models do
    Repo.all(Model)
  end

  @doc """
  Gets a single model.

  Raises `Ecto.NoResultsError` if the Model does not exist.

  ## Examples

      iex> get_model!(123)
      %Model{}

      iex> get_model!(456)
      ** (Ecto.NoResultsError)

  """
  def get_model(id), do: Repo.get(Model, id)

  @doc """
  Creates a model.

  ## Examples

      iex> create_model(%{field: value})
      {:ok, %Model{}}

      iex> create_model(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_model(attrs \\ %{}) do
    %Model{}
    |> Model.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a model.

  ## Examples

      iex> update_model(model, %{field: new_value})
      {:ok, %Model{}}

      iex> update_model(model, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_model(%Model{} = model, attrs) do
    model
    |> Model.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a model.

  ## Examples

      iex> delete_model(model)
      {:ok, %Model{}}

      iex> delete_model(model)
      {:error, %Ecto.Changeset{}}

  """
  def delete_model(%Model{} = model) do
    Repo.delete(model)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking model changes.

  ## Examples

      iex> change_model(model)
      %Ecto.Changeset{data: %Model{}}

  """
  def change_model(%Model{} = model, attrs \\ %{}) do
    Model.changeset(model, attrs)
  end

  alias Starwebbie.Items.Type

  @doc """
  Returns the list of types.

  ## Examples

      iex> list_types()
      [%Type{}, ...]

  """
  def list_types do
    Repo.all(Type)
  end

  @doc """
  Gets a single type.

  Raises `Ecto.NoResultsError` if the Type does not exist.

  ## Examples

      iex> get_type!(123)
      %Type{}

      iex> get_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_type(id), do: Repo.get(Type, id)

  @doc """
  Creates a type.

  ## Examples

      iex> create_type(%{field: value})
      {:ok, %Type{}}

      iex> create_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_type(attrs \\ %{}) do
    %Type{}
    |> Type.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a type.

  ## Examples

      iex> update_type(type, %{field: new_value})
      {:ok, %Type{}}

      iex> update_type(type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_type(%Type{} = type, attrs) do
    type
    |> Type.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a type.

  ## Examples

      iex> delete_type(type)
      {:ok, %Type{}}

      iex> delete_type(type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_type(%Type{} = type) do
    Repo.delete(type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking type changes.

  ## Examples

      iex> change_type(type)
      %Ecto.Changeset{data: %Type{}}

  """
  def change_type(%Type{} = type, attrs \\ %{}) do
    Type.changeset(type, attrs)
  end

  alias Starwebbie.Items.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item) |> Repo.preload([:model, :type, :owner])
  end

  def list_items(user_id: user_id) do
    from(i in Item,
      where: i.owner_id == ^user_id,
      preload: [:model, :type]
    )
    |> Repo.all()
  end

  def list_items_by_type_id(type_id) do
    query = from(i in Item, where: i.type_id == ^type_id)
    Repo.all(query) |> Repo.preload([:model, :type])
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item(id), do: Repo.get(Item, id) |> Repo.preload([:model, :type])

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  def buy_item(item_id, user_id) do
    with item when not is_nil(item) <- get_item(item_id),
         user <- Starwebbie.Users.get_users!(user_id),
         original_owner <- Starwebbie.Users.get_users!(item.owner_id),
         price <- item.type.multiplier * item.model.index_price do
      Ecto.Multi.new()
      |> Ecto.Multi.run(:check_balance, fn _repo, _changes ->
        case user.balance >= price do
          true -> {:ok, :ok}
          false -> {:error, :insufficient_balance}
        end
      end)
      |> Ecto.Multi.update(
        :update_buyer,
        Starwebbie.Users.change_users(user, %{balance: user.balance - price})
      )
      |> Ecto.Multi.update(
        :update_seller,
        Starwebbie.Users.change_users(original_owner, %{balance: user.balance + price})
      )
      |> Ecto.Multi.update(
        :update_item,
        change_item(item, %{owner_id: user.id})
      )
      |> Repo.transaction()
    end
  end

  @doc """
  Trades an item with another user.
  """
  @spec trade_item(item_id :: integer, seller_id :: integer, buyer_id :: integer) ::
          any()
  def trade_item(item_id, seller_id, buyer_id) do
    with item when not is_nil(item) <- get_item(item_id),
         buyer <- Starwebbie.Users.get_users!(buyer_id),
         seller <- Starwebbie.Users.get_users!(seller_id),
         true <- item.owner_id == seller.id,
         price <- item.type.multiplier * item.model.index_price do
      Ecto.Multi.new()
      |> Ecto.Multi.run(:check_balance, fn _repo, _changes ->
        case buyer.balance >= price do
          true -> {:ok, :ok}
          false -> {:error, :insufficient_balance}
        end
      end)
      |> Ecto.Multi.update(
        :update_buyer,
        Starwebbie.Users.change_users(buyer, %{balance: buyer.balance - price})
      )
      |> Ecto.Multi.update(
        :update_seller,
        Starwebbie.Users.change_users(seller, %{balance: seller.balance + price})
      )
      |> Ecto.Multi.update(
        :update_item,
        change_item(item, %{owner_id: buyer.id})
      )
      |> Repo.transaction()
    end
  end
end
