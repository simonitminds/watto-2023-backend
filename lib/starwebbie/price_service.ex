defmodule Starwebbie.PriceService do
  use GenServer

  @impl true
  def init(0) do
    {:ok, 0}
    Process.send_after(self(), :update_prices, 5000)
  end

  @impl true
  def handle_info(:update_prices, state) do
    types = Starwebbie.Items.list_types()
    Enum.each(types, fn type ->
      Starwebbie.Items.update_type(type, %{multiplicator: type.multiplicator + 1})
    end
    {:noreply, state + 1}
  end
end
