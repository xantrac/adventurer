defmodule AdventurerWeb.Schema.Resolvers.Story do
  def get_story(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    {:ok, Adventurer.Stories.get_story!(id, current_user)}
  end
end
