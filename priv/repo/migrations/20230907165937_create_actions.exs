defmodule Adventurer.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:choices) do
      add :description, :string
      add :origin_node_id, references(:nodes, on_delete: :delete_all), null: false
      add :target_node_id, references(:nodes, on_delete: :nothing), null: false
      add :story_id, references(:stories, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
