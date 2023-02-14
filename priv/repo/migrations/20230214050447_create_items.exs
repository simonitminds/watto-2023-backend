defmodule Starwebbie.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :owner_id, references(:users, on_delete: :nothing)
      add :model_id, references(:models, on_delete: :nothing)
      add :type_id, references(:types, on_delete: :nothing)

      timestamps()
    end

    create index(:items, [:owner_id])
    create index(:items, [:model_id])
    create index(:items, [:type_id])
  end
end
