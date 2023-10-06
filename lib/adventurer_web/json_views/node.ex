defmodule AdventurerWeb.JsonViews.Node do
  use JSONAPI.View, type: "nodes"

  def fields do
    [:title, :body, :is_final_node]
  end
end
