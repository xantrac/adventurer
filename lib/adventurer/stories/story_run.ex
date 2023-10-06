defmodule Adventurer.Stories.StoryRun do
  use Adventurer.Schema
  import Ecto.Changeset

  schema "story_runs" do
    field :started_at, :utc_datetime
    field :ended_at, :utc_datetime

    belongs_to :current_node, Adventurer.Nodes.Node
    belongs_to :user, Adventurer.Accounts.User
    belongs_to :story, Adventurer.Stories.Story

    timestamps()
  end

  @doc false
  def changeset(story_run, attrs) do
    story_run
    |> cast(attrs, [:user_id, :story_id, :current_node_id, :ended_at])
    |> validate_required([:user_id, :story_id, :current_node_id])
    |> set_started_at()
  end

  defp set_started_at(changeset) do
    put_change(changeset, :started_at, Timex.now() |> DateTime.truncate(:second))
  end
end
