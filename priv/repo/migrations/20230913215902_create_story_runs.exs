defmodule Adventurer.Repo.Migrations.CreateStoryRuns do
  use Ecto.Migration

  def change do
    create table(:story_runs) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :story_id, references(:stories, on_delete: :nothing), null: false
      add :current_node_id, references(:nodes, on_delete: :nothing), null: false
      add :started_at, :utc_datetime, null: false
      add :ended_at, :utc_datetime

      timestamps()
    end

    create table(:user_choices) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :choice_id, references(:choices, on_delete: :nothing), null: false
      add :story_id, references(:nodes, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
