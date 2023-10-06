defmodule AdventurerWeb.Schema do
  use Absinthe.Schema
  import_types(AdventurerWeb.Schema.StoryTypes)

  query do
    @desc "Get all stories"
    field :stories, list_of(:story) do
      resolve(&AdventurerWeb.Schema.Resolvers.Story.list_stories/3)
    end

    @desc "Get a story by ID"
    field :story, :story do
      arg(:id, non_null(:id))
      resolve(&AdventurerWeb.Schema.Resolvers.Story.get_story/3)
    end
  end
end
