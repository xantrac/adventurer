defmodule Adventurer.Nodes do
  alias Adventurer.Repo
  alias Adventurer.Nodes.Node

  def get_node!(id) do
    Repo.get!(Node, id)
    |> Repo.preload(choices: [:origin_node, :target_node])
  end

  def create_node(attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:node, Node.changeset(%Node{}, attrs))
    |> Ecto.Multi.insert(:choice, fn %{node: node} ->
      Adventurer.Stories.Choice.changeset(%Adventurer.Stories.Choice{}, %{
        origin_node_id: attrs.original_node_id,
        target_node_id: node.id,
        description: "Continue"
      })
      |> Repo.transaction()
      |> case do
        {:ok, choice} -> dbg(choice)
        {:error, changeset} -> changeset
      end
    end)

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
