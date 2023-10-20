defmodule Adventurer.Nodes.Node do
  use Adventurer.Schema
  import Ecto.Changeset

  schema "nodes" do
    field :title, :string
    field :body, :string
    field :is_final_node, :boolean, default: false

    belongs_to :story, Adventurer.Stories.Story
    has_many :choices, Adventurer.Stories.Choice, foreign_key: :origin_node_id
    has_many :choice_targets, Adventurer.Stories.Choice, foreign_key: :target_node_id

    timestamps()
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [:title, :body, :story_id, :is_final_node])
    |> validate_required([:title, :body, :story_id, :is_final_node])
  end
end
