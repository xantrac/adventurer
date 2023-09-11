defmodule Adventurer.Stories do
  import Ecto.Query, warn: false
  alias Adventurer.Repo

  alias Adventurer.Stories.{Story, Node, Choice}

  def list_stories do
    Repo.all(Story)
  end

  def get_story!(id) do
    Repo.get!(Story, id)
    |> Repo.preload(:nodes)
  end

  def create_story(attrs \\ %{}) do
    %Story{}
    |> Story.changeset(attrs)
    |> Repo.insert()
  end

  def update_story(%Story{} = story, attrs) do
    story
    |> Story.changeset(attrs)
    |> Repo.update()
  end

  def delete_story(%Story{} = story) do
    Repo.delete(story)
  end

  def change_story(%Story{} = story, attrs \\ %{}) do
    Story.changeset(story, attrs)
  end

  def get_node!(id) do
    Repo.get!(Node, id)
    |> Repo.preload(choices: [choice_targets: :target_node])
  end

  def create_node(attrs \\ %{}) do
    %Node{}
    |> Node.changeset(attrs)
    |> Repo.insert()
  end

  def update_node(%Node{} = node, attrs) do
    node
    |> Node.changeset(attrs)
    |> Repo.update()
  end

  def delete_node(%Node{} = node) do
    Repo.delete(node)
  end

  def change_node(%Node{} = node, attrs \\ %{}) do
    Node.changeset(node, attrs)
  end

  def change_choice(%Choice{} = choice, attrs \\ %{}) do
    Choice.changeset(choice, attrs)
  end

  def create_choice(attrs \\ %{}) do
    %Choice{}
    |> Choice.changeset(attrs)
    |> Repo.insert()
  end
end
