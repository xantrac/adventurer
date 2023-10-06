defmodule Adventurer.Nodes do
  alias Adventurer.Repo
  alias Adventurer.Nodes.Node

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
end
