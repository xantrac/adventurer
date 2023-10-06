defmodule Adventurer.StoriesTest do
  use Adventurer.DataCase

  alias Adventurer.Stories

  describe "stories" do
    alias Adventurer.Stories.Story

    import Adventurer.StoriesFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_stories/0 returns all stories" do
      story = story_fixture()
      assert Stories.list_stories() == [story]
    end

    test "get_story!/1 returns the story with given id" do
      story = story_fixture()
      assert Stories.get_story!(story.id) == story
    end

    test "create_story/1 with valid data creates a story" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %Story{} = story} = Stories.create_story(valid_attrs)
      assert story.description == "some description"
      assert story.title == "some title"
    end

    test "create_story/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stories.create_story(@invalid_attrs)
    end

    test "update_story/2 with valid data updates the story" do
      story = story_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Story{} = story} = Stories.update_story(story, update_attrs)
      assert story.description == "some updated description"
      assert story.title == "some updated title"
    end

    test "update_story/2 with invalid data returns error changeset" do
      story = story_fixture()
      assert {:error, %Ecto.Changeset{}} = Stories.update_story(story, @invalid_attrs)
      assert story == Stories.get_story!(story.id)
    end

    test "delete_story/1 deletes the story" do
      story = story_fixture()
      assert {:ok, %Story{}} = Stories.delete_story(story)
      assert_raise Ecto.NoResultsError, fn -> Stories.get_story!(story.id) end
    end

    test "change_story/1 returns a story changeset" do
      story = story_fixture()
      assert %Ecto.Changeset{} = Stories.change_story(story)
    end
  end

  describe "nodes" do
    alias Adventurer.Nodes.Node

    import Adventurer.StoriesFixtures

    @invalid_attrs %{title: nil, body: nil}

    test "list_nodes/0 returns all nodes" do
      node = node_fixture()
      assert Stories.list_nodes() == [node]
    end

    test "get_node!/1 returns the node with given id" do
      node = node_fixture()
      assert Stories.get_node!(node.id) == node
    end

    test "create_node/1 with valid data creates a node" do
      valid_attrs = %{title: "some title", body: "some body"}

      assert {:ok, %Node{} = node} = Stories.create_node(valid_attrs)
      assert node.title == "some title"
      assert node.body == "some body"
    end

    test "create_node/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stories.create_node(@invalid_attrs)
    end

    test "update_node/2 with valid data updates the node" do
      node = node_fixture()
      update_attrs = %{title: "some updated title", body: "some updated body"}

      assert {:ok, %Node{} = node} = Stories.update_node(node, update_attrs)
      assert node.title == "some updated title"
      assert node.body == "some updated body"
    end

    test "update_node/2 with invalid data returns error changeset" do
      node = node_fixture()
      assert {:error, %Ecto.Changeset{}} = Stories.update_node(node, @invalid_attrs)
      assert node == Stories.get_node!(node.id)
    end

    test "delete_node/1 deletes the node" do
      node = node_fixture()
      assert {:ok, %Node{}} = Stories.delete_node(node)
      assert_raise Ecto.NoResultsError, fn -> Stories.get_node!(node.id) end
    end

    test "change_node/1 returns a node changeset" do
      node = node_fixture()
      assert %Ecto.Changeset{} = Stories.change_node(node)
    end
  end

  describe "actions" do
    alias Adventurer.Stories.Action

    import Adventurer.StoriesFixtures

    @invalid_attrs %{}

    test "list_actions/0 returns all actions" do
      action = action_fixture()
      assert Stories.list_actions() == [action]
    end

    test "get_action!/1 returns the action with given id" do
      action = action_fixture()
      assert Stories.get_action!(action.id) == action
    end

    test "create_action/1 with valid data creates a action" do
      valid_attrs = %{}

      assert {:ok, %Action{} = action} = Stories.create_action(valid_attrs)
    end

    test "create_action/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stories.create_action(@invalid_attrs)
    end

    test "update_action/2 with valid data updates the action" do
      action = action_fixture()
      update_attrs = %{}

      assert {:ok, %Action{} = action} = Stories.update_action(action, update_attrs)
    end

    test "update_action/2 with invalid data returns error changeset" do
      action = action_fixture()
      assert {:error, %Ecto.Changeset{}} = Stories.update_action(action, @invalid_attrs)
      assert action == Stories.get_action!(action.id)
    end

    test "delete_action/1 deletes the action" do
      action = action_fixture()
      assert {:ok, %Action{}} = Stories.delete_action(action)
      assert_raise Ecto.NoResultsError, fn -> Stories.get_action!(action.id) end
    end

    test "change_action/1 returns a action changeset" do
      action = action_fixture()
      assert %Ecto.Changeset{} = Stories.change_action(action)
    end
  end
end
