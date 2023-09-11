defmodule Adventurer.Stories.Node do
  use Ecto.Schema
  import Ecto.Changeset

  schema "nodes" do
    field :title, :string
    field :body, :map

    belongs_to :story, Adventurer.Stories.Story
    has_many :choices, Adventurer.Stories.Choice

    timestamps()
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [:title, :body, :story_id])
    |> validate_required([:title, :body, :story_id])
  end
end
