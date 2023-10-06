defmodule AdventurerWeb.JsonViews.Story do
  use JSONAPI.View, type: "stories"

  def fields do
    [:description, :title, :cover_image_url, :published_at, :starting_node_id]
  end

  def relationships do
    [nodes: {AdventurerWeb.JsonViews.Node, :include}]
  end
end
