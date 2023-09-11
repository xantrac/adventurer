defmodule Adventurer.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:choices) do
      add :description, :string
      add :node_id, references(:nodes, on_delete: :delete_all), null: false

      timestamps()
    end

    create table(:choice_targets) do
      add :target_node_id, references(:nodes, on_delete: :nothing), null: false
      add :choice_id, references(:choices, on_delete: :delete_all), null: false
      add :probability, :integer, default: 100, null: false

      timestamps()
    end
  end
end
