defmodule AdventurerWeb.BreadCrumbs do
  use AdventurerWeb, :component

  def render(assigns) do
    ~H"""
    <nav class="flex" aria-label="Breadcrumb">
      <ol role="list" class="flex items-center space-x-4">
        <%= for crumb <- crumbs(Path.split(@current_path), assigns) do %>
          <.crumb_link {crumb} />
          <%= unless is_last_crumb?(crumb) do %>
            <.divider />
          <% end %>
        <% end %>
      </ol>
    </nav>
    """
  end

  def crumbs(["/", "my", "stories", id, "nodes", node_id], %{
        story: %{id: id, title: title},
        node: %{id: node_id, title: node_title}
      }) do
    [
      my_home(),
      %{
        label: title,
        path: ~p"/my/stories/#{id}"
      },
      %{
        label: node_title,
        path: ~p"/my/stories/#{id}/nodes/#{node_id}",
        is_last: true
      }
    ]
  end

  def crumbs(["/", "my", "stories", id | _], %{story: %{id: id, title: title}}) do
    [
      my_home(),
      %{
        label: title,
        path: ~p"/my/stories/#{id}",
        is_last: true
      }
    ]
  end

  def crumbs(["/", "my", "stories"], _) do
    [
      my_home(true)
    ]
  end

  def crumbs(_, _), do: []

  defp my_home(is_last \\ false) do
    %{
      label: "My Stories",
      path: ~p"/my/stories",
      is_last: is_last
    }
  end

  defp is_last_crumb?(%{is_last: true}), do: true
  defp is_last_crumb?(_), do: false

  def crumb_link(assigns) do
    ~H"""
    <li>
      <div class="flex">
        <.link patch={@path} class="text-sm font-medium text-gray-500 hover:text-gray-700">
          <%= @label %>
        </.link>
      </div>
    </li>
    """
  end

  def divider(assigns) do
    ~H"""
    <.icon name="hero-chevron-right-mini" class="h-5 w-5 flex-shrink-0 text-gray-400" />
    """
  end
end
