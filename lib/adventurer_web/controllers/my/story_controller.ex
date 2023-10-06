defmodule AdventurerWeb.My.StoryController do
  use AdventurerWeb, :controller

  def index(conn, _) do
    render(conn, :index, layout: false)
  end
end
