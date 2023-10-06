defmodule Adventurer.Repo.Migrations.CreateNodes do
  use Ecto.Migration

  def change do
    create table(:nodes) do
      add :title, :string
      add :body, :map, default: %{}
      add :story_id, references(:stories, on_delete: :nothing), null: false
      add :is_final_node, :boolean, default: false

      timestamps()
    end

    alter table(:stories) do
      add :starting_node_id, references(:nodes, on_delete: :delete_all)
    end

    create index(:nodes, [:story_id])
  end
end
