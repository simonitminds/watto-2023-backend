# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Starwebbie.Repo.insert!(%Starwebbie.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Starwebbie.Users
alias Starwebbie.Items

type_names = ~w[crystal_vibrator hilt crystal power_core]
model_names = ~w[gilded golden royal regal silvered enchanted embossed]

rand_number_f = fn -> :rand.uniform() end
rand_number_i = fn -> :rand.uniform() |> trunc() end

types =
  type_names
  |> Enum.map(fn name ->
    {:ok, type} = Items.create_type(%{name: name, multiplier: rand_number_f.()})
    type
  end)

models =
  model_names
  |> Enum.map(fn name ->
    {:ok, model} = Items.create_model(%{name: name, index_price: rand_number_i.()})
    model
  end)

{:ok, user} =
  Users.create_users(%{
    username: "dark_saber_dealer",
    password: "notwatto"
  })

items =
  for model <- models, type <- types do
    Items.create_item(%{
      name: "#{model.name} #{type.name}",
      model_id: model.id,
      type_id: type.id,
      owner_id: user.id
    })
  end
