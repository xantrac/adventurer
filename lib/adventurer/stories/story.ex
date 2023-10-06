defmodule Adventurer.Stories.Story do
  use Adventurer.Schema
  import Ecto.Changeset

  schema "stories" do
    field :description, :string
    field :title, :string
    field :cover_image_url, :string
    field :published_at, :utc_datetime
    field :starting_node_id, :binary_id

    belongs_to :user, Adventurer.Accounts.User
    has_many :nodes, Adventurer.Nodes.Node

    timestamps()
  end

  @doc false
  def changeset(story, attrs) do
    story
    |> cast(attrs, [
      :title,
      :description,
      :user_id,
      :published_at,
      :cover_image_url,
      :starting_node_id
    ])
    |> validate_required([:title, :description, :user_id])
  end

  def create_changeset(story, attrs) do
    story
    |> changeset(attrs)
    |> add_default_image_url()
    |> cast_assoc(:nodes)
  end

  def add_default_image_url(%{changes: %{title: title}} = changeset) do
    case get_field(changeset, :cover_image_url) do
      nil ->
        search_terms = title |> String.split(" ") |> Enum.join(",")

        put_change(
          changeset,
          :cover_image_url,
          Adventurer.Clients.Unsplash.get_random_image(search_terms)
        )

      _ ->
        changeset
    end
  end
end
