defmodule Starwebbie.PriceService do
  use GenServer

  @impl true
  def init(init \\ 0) do
    Process.send_after(self(), :update_prices, 5000)
    {:ok, init}
  end

  @impl true
  def handle_info(:update_prices, state) do
    types = Starwebbie.Items.list_types()

    rand_number_f = fn -> :rand.uniform() end

    Enum.each(types, fn type ->
      Starwebbie.Items.update_type(type, %{multiplier: rand_number_f.()})
    end)

    Process.send_after(self(), :update_prices, 60 * 1000)
    broadcast()

    {:noreply, state + 1}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, 0)
  end

  def broadcast() do
    user_id = 1
    items = Starwebbie.Items.list_items(user_id: user_id)
    Absinthe.Subscription.publish(StarwebbieWeb.Endpoint, items, marketplace: "*")
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(Starwebbie.PubSub, "market")
  end
end
