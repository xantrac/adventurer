defmodule AdventurerWeb.Preview do
  use AdventurerWeb, :component

  def render(assigns) do
    ~H"""
    <div id="story-preview" phx-hook="EditorHtml">
      <h1>Preview</h1>
      <div id="preview" />
      <%= for choice <- @current_node.choices |> with_target do %>
        <.link patch={choice_url(@current_node, choice)}>
          <%= choice.description %>
        </.link>
      <% end %>
    </div>
    """
  end

  def with_target(choices) do
    Enum.filter(choices, fn choice ->
      choice.choice_targets != []
    end)
  end

  def choice_url(current_node, choice) do
    [choice_target] = choice.choice_targets
    ~p"/my/stories/#{current_node.story_id}/preview/nodes/#{choice_target.target_node_id}"
  end
end
