defmodule Adventurer.Stories.ChoiceTarget do
  use Ecto.Schema
  import Ecto.Changeset

  schema "choice_targets" do
    field :probability, :integer, default: 100

    belongs_to :choice, Adventurer.Stories.Choice
    belongs_to :target_node, Adventurer.Stories.Node

    timestamps()
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [:choice_id, :target_node_id, :probability])
    |> validate_required([:target_node_id])
  end
end
