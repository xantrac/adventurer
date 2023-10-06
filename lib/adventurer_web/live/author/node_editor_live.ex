defmodule AdventurerWeb.Author.NodeEditorLive do
  use AdventurerWeb, :live_view

  def render(assigns) do
    ~H"""
    <div phx-hook="NodesBuilder" phx-update="ignore" class="h-screen w-screen" id="nodes-builder" />
    """
  end
end
