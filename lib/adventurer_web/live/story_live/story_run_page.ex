defmodule AdventurerWeb.StoryLive.Run do
  use AdventurerWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    current_user = socket.assigns.current_user
    story = Adventurer.Stories.get_story!(id)
    story_run = Adventurer.Stories.get_story_run(%{user_id: current_user.id, story_id: story.id})

    {:ok, assign(socket, story: story, story_run: story_run)}
  end

  def render(assigns) do
    ~H"""
    ccatu
    """
  end
end
