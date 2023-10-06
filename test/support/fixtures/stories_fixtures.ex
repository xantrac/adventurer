defmodule Adventurer.StoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Adventurer.Stories` context.
  """

  @doc """
  Generate a story.
  """
  def story_fixture(attrs \\ %{}) do
    {:ok, story} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Adventurer.Stories.create_story()

    story
  end

  @doc """
  Generate a node.
  """
  def node_fixture(attrs \\ %{}) do
    {:ok, node} =
      attrs
      |> Enum.into(%{
        title: "some title",
        body: "some body"
      })
      |> Adventurer.Stories.create_node()

    node
  end

  @doc """
  Generate a action.
  """
  def action_fixture(attrs \\ %{}) do
    {:ok, action} =
      attrs
      |> Enum.into(%{})
      |> Adventurer.Stories.create_action()

    action
  end
end
