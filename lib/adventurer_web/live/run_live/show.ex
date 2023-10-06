defmodule AdventurerWeb.RunLive.Show do
  alias Adventurer.Stories
  use AdventurerWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    current_user = socket.assigns.current_user

    story_run = Adventurer.Stories.get_story_run(%{user_id: current_user.id, id: id})

    story = Adventurer.Stories.get_story!(story_run.story_id)

    {:noreply,
     socket
     |> assign(story: story, story_run: story_run)
     |> push_event("set_html", %{data: story_run.current_node.body})}
  end

  def render(assigns) do
    ~H"""
    <div class="p-4 flex flex-col items-center">
      <h1 class="text-2xl"><%= @story.title %></h1>
      <div class="sm:max-w-2xl mt-6">
        <div id="story-run-preview">
          <div class="space-y-4">
            <%= render_editor_html(@story_run.current_node) %>
          </div>
        </div>
        <div class="grid grid-cols-2 gap-4 mt-8">
          <%= for choice <- @story_run.current_node.choices |> with_target do %>
            <.button phx-click={"go_to_next_node_#{next_node(choice)}"}>
              <%= choice.description %>
            </.button>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("go_to_next_node_" <> node_id, _unsigned_params, socket) do
    node = Adventurer.Nodes.get_node!(node_id)
    run = socket.assigns.story_run

    case Stories.update_story_run(run, %{current_node_id: node.id}) do
      {:ok, _} ->
        {:noreply, socket |> push_patch(to: ~p"/runs/#{run.id}")}

      {:error, _} ->
        {:noreply, socket |> push_event("error", %{message: "Something went wrong"})}
    end
  end

  def next_node(%{choice_targets: [%{target_node_id: target_node_id}]}) do
    target_node_id
  end

  def with_target(choices) do
    Enum.filter(choices, fn choice ->
      choice.choice_targets != []
    end)
  end

  defp render_editor_html(node) do
    raw(Adventurer.EditorJs.blocks_to_html(node.body))
  end
end
