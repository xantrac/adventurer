defmodule Adventurer.Stories.Choice do
  use Adventurer.Schema
  import Ecto.Changeset

  schema "choices" do
    field :description, :string
    belongs_to(:origin_node, Adventurer.Nodes.Node)
    belongs_to(:target_node, Adventurer.Nodes.Node)

    belongs_to(:story, Adventurer.Stories.Story)

    timestamps()
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [:description, :origin_node_id, :target_node_id])
    |> validate_required([:description, :origin_node_id, :target_node_id])
  end
end
