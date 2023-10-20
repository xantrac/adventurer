defmodule AdventurerWeb.Schema.StoryTypes do
  use Absinthe.Schema.Notation

  object :story do
    field :id, :id
    field :title, :string
    field :description, :string
    field :starting_node_id, :id
    field :nodes, list_of(:node)
    field :choices, list_of(:choice)
  end

  object :node do
    field :id, :id
    field :title, :string
    field :body, :string
    field :story_id, :id
    field :choices, list_of(:choice)
  end

  input_object :node_input do
    field :title, :string
    field :body, :string
    field :story_id, :id
    field :is_final_node, :boolean
    field :origin_node_id, :id
  end

  object :choice do
    field :id, :id
    field :description, :string
    field :origin_node_id, :id
    field :target_node_id, :id
  end
end
