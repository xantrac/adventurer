defmodule AdventurerWeb.NodeLive.New do
  alias Adventurer.Stories
  alias Adventurer.Stories.Node

  use AdventurerWeb, :live_view

  def mount(params, _session, socket) do
    story = Stories.get_story!(params["id"])

    socket =
      socket
      |> assign(:page_title, "New Node")
      |> assign(:story, story)
      |> assign_form(Stories.change_node(%Node{}))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="grid sm:grid-cols-2 gap-8">
      <div>
        <.simple_form for={@form} id="node-form" phx-submit="save">
          <div class="col-span-full">
            <.input field={@form[:title]} type="text" label="Title" />
          </div>
          <div class="col-span-full">
            <.input field={@form[:body]} type="textarea" label="Content" />
          </div>
          <:actions>
            <.button phx-disable-with="Saving...">Save Node</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def handle_event("save", %{"node" => params}, socket) do
    story = socket.assigns.story
    params = Map.put(params, "story_id", story.id)

    dbg(params)
    {:ok, node} = Stories.create_node(params)

    {:noreply, socket |> redirect(to: ~p"/stories/#{story.id}/nodes/#{node.id}")}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
