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

    if connected?(socket) do
      {:ok, push_event(socket, "initialize_editor", %{data: %{}})}
    else
      {:ok, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="grid sm:grid-cols-2 gap-8">
      <AdventurerWeb.NodeLive.NodeForm.render form={@form} />
    </div>
    """
  end

  def handle_event("save", %{"node" => params}, socket) do
    {:noreply,
     socket
     |> assign(:params, params)
     |> push_event("save_editor", %{})}
  end

  def handle_event("save_node", %{"data" => body}, socket) do
    %{params: params, story: story} = socket.assigns
    params = Map.merge(params, %{"body" => body, "story_id" => story.id})

    {:ok, node} = Stories.create_node(params)

    {:noreply, socket |> redirect(to: ~p"/my/stories/#{story.id}/nodes/#{node.id}")}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
