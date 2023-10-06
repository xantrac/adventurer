defmodule AdventurerWeb.Schema.StoryTypes do
  use Absinthe.Schema.Notation

  import_types(AdventurerWeb.Schema.Json)

  object :story do
    field :id, :id
    field :title, :string
    field :description, :string
    field :starting_node_id, :id
    field :nodes, list_of(:node)
  end

  object :node do
    field :id, :id
    field :title, :string
    field :body, :json
    field :story_id, :id
    field :choices, list_of(:choice)
  end

  object :node_body do
    field :text, :string
  end

  object :choice do
    field :description, :string
    field :choice_targets, list_of(:choice_target)
  end

  object :choice_target do
    field :target_node, :node
  end
end
