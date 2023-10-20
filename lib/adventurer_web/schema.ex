defmodule AdventurerWeb.Schema do
  use Absinthe.Schema
  import_types(AdventurerWeb.Schema.StoryTypes)

  query do
    @desc "Get a story by ID"
    field :story, :story do
      arg(:id, non_null(:id))
      resolve(&AdventurerWeb.Schema.Resolvers.Story.get_story/3)
    end
  end

  mutation do
    @desc "Create a new node"
    field :create_node, :node do
      arg(:node_input, non_null(:node_input))
      resolve(&AdventurerWeb.Schema.Resolvers.Node.create_node/3)
    end

    @desc "Update a node"
    field :update_node, :node do
      arg(:id, non_null(:id))
      arg(:node_input, non_null(:node_input))
      resolve(&AdventurerWeb.Schema.Resolvers.Node.update_node/3)
    end
  end
end
