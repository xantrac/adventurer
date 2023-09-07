defmodule Adventurer.Stories.Story do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stories" do
    field :description, :string
    field :title, :string
    field :user_id, :id

    has_many :nodes, Adventurer.Stories.Node

    timestamps()
  end

  @doc false
  def changeset(story, attrs) do
    story
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
