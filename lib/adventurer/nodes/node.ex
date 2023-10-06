defmodule Adventurer.Nodes.Node do
  use Adventurer.Schema
  import Ecto.Changeset

  schema "nodes" do
    field :title, :string
    field :body, :map
    field :is_final_node, :boolean, default: false
    field :html_body, :string, virtual: true

    belongs_to :story, Adventurer.Stories.Story
    has_many :choices, Adventurer.Stories.Choice

    timestamps()
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [:title, :body, :story_id, :is_final_node])
    |> validate_required([:title, :body, :story_id, :is_final_node])
  end
end
