defmodule Adventurer.Repo.Migrations.CreateNodes do
  use Ecto.Migration

  def change do
    create table(:nodes) do
      add :title, :string
      add :body, :map, default: %{}
      add :story_id, references(:stories, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:nodes, [:story_id])
  end
end
