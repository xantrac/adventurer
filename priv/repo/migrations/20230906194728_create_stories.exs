defmodule Adventurer.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def change do
    create table(:stories) do
      add :title, :string, null: false
      add :description, :text, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :published_at, :utc_datetime
      add :cover_image_url, :string

      timestamps()
    end

    create index(:stories, [:user_id])
  end
end
