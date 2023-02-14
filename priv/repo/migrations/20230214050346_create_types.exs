defmodule Starwebbie.Repo.Migrations.CreateTypes do
  use Ecto.Migration

  def change do
    create table(:types) do
      add :name, :string
      add :multiplier, :float

      timestamps()
    end
  end
end
