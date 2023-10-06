defmodule Adventurer.Stories.Choice do
  use Adventurer.Schema
  import Ecto.Changeset

  schema "choices" do
    field :description, :string
    belongs_to(:node, Adventurer.Nodes.Node)
    has_many(:choice_targets, Adventurer.Stories.ChoiceTarget)

    timestamps()
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [:description, :node_id])
    |> validate_required([:description, :node_id])
    |> cast_assoc(:choice_targets)
  end
end
