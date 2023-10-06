defmodule Adventurer.Stories do
  import Ecto.Query, warn: false
  alias Adventurer.Repo

  alias Adventurer.Stories.{Story, StoryRun}

  def list_stories() do
    Story
    |> order_by([s], desc: s.inserted_at)
    |> Repo.all()
  end

  def list_stories(user) do
    Story
    |> where([s], s.user_id == ^user.id)
    |> order_by([s], desc: s.inserted_at)
    |> Repo.all()
  end

  def get_story!(id, user) do
    Story
    |> where([s], s.user_id == ^user.id)
    |> Repo.get!(id)
    |> Repo.preload(nodes: [choices: :choice_targets])
  end

  def get_story_run(%{id: id, user_id: user_id}) do
    Repo.get_by(StoryRun, id: id, user_id: user_id)
    |> Repo.preload(current_node: [choices: :choice_targets])
  end

  def create_story_run(%Adventurer.Accounts.User{id: user_id}, %Story{
        id: story_id,
        starting_node_id: initial_node
      }) do
    %StoryRun{}
    |> StoryRun.changeset(%{user_id: user_id, story_id: story_id, current_node_id: initial_node})
    |> Repo.insert()
  end

  def update_story_run(%StoryRun{} = story_run, attrs) do
    story_run
    |> StoryRun.changeset(attrs)
    |> Repo.update()
  end

  def create_story(attrs \\ %{}, %Adventurer.Accounts.User{id: user_id}) do
    attrs = Map.put(attrs, "user_id", user_id)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:story, Story.create_changeset(%Story{}, attrs))
    |> Ecto.Multi.insert(:starting_node, fn %{story: story} ->
      Adventurer.Nodes.Node.changeset(%Adventurer.Nodes.Node{}, %{
        story_id: story.id,
        title: "Prologue",
        body: %{}
      })
    end)
    |> Ecto.Multi.update(:updated_story, fn %{story: story, starting_node: starting_node} ->
      Story.changeset(story, %{starting_node_id: starting_node.id})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{story: story}} ->
        {:ok, story}

      {:error, _} ->
        {:error, "Failed to create story"}
    end
  end

  def update_story(%Story{} = story, attrs) do
    story
    |> Story.changeset(attrs)
    |> Repo.update()
  end

  def publish_story(%Story{} = story) do
    story
    |> Story.changeset(%{published_at: Timex.now()})
    |> Repo.update()
  end

  def change_story(%Story{} = story, attrs \\ %{}) do
    Story.changeset(story, attrs)
  end
end
