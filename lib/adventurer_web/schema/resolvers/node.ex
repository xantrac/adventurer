defmodule AdventurerWeb.Schema.Resolvers.Node do
  def create_node(_parent, %{node_input: node_input}, _) do
    Adventurer.Nodes.create_node(node_input)
  end

  def update_node(_parent, %{id: id, node_input: node_input}, _) do
    node = Adventurer.Nodes.get_node!(id)
    Adventurer.Nodes.update_node(node, node_input)
  end
end
