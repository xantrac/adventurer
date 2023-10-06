defmodule AdventurerWeb.StoryLive.Preview do
  use AdventurerWeb, :live_view

  alias Adventurer.Stories

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    story = Stories.get_story!(id)
    {:ok, assign(socket, story: story)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto flex flex-col items-center p-4 space-y-4">
      <h2 class="text-2xl"><%= @story.title %></h2>
      <div class="group block overflow-hidden w-72 h-72 rounded-lg bg-gray-100">
        <img src={@story.cover_image_url} class="object-cover h-full w-full" />
      </div>
      <p><%= @story.description %></p>
      <.button phx-click="create_new_story_run">
        Start a new run
      </.button>
    </div>
    """
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:story, Stories.get_story!(id))}
  end

  @impl true
  def handle_event("create_new_story_run", _, socket) do
    current_user = socket.assigns.current_user
    story = socket.assigns.story

    case Stories.create_story_run(current_user, story) |> dbg do
      {:ok, story_run} ->
        {:noreply, push_navigate(socket, to: ~p"/runs/#{story_run.id}")}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  defp page_title(:show), do: "Show Story"
  defp page_title(:edit), do: "Edit Story"
end
