defmodule AdventurerWeb.NodeLive.ChoiceForm do
  use AdventurerWeb, :component

  attr :form, :any, required: true
  attr :nodes, :list, required: true
  attr :node_id, :integer, required: true

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-submit="save_choice" class="space-y-4">
        <.input type="hidden" field={@form[:node_id]} value={@node_id} />
        <div>
          <.input
            label="Choice"
            placeholder="Walk through the door..."
            type="text"
            field={@form[:description]}
          />
        </div>
        <.inputs_for :let={destination_form} field={@form[:choice_targets]}>
          <div class="flex-1">
            <.input
              label="Target Node"
              type="select"
              field={destination_form[:target_node_id]}
              options={options_for_nodes(@nodes)}
            />
          </div>
        </.inputs_for>

        <div class="flex justify-end">
          <.button phx-disable-with="Saving...">Save</.button>
        </div>
      </.form>
    </div>
    """
  end

  defp options_for_nodes(nodes) do
    Enum.map(nodes, fn node -> {node.title, node.id} end)
  end
end
