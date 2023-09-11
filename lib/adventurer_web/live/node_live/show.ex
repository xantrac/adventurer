defmodule AdventurerWeb.NodeLive.Show do
  use AdventurerWeb, :live_view
  alias Adventurer.Stories

  def mount(%{"id" => story_id, "node_id" => node_id}, _session, socket) do
    node = Stories.get_node!(node_id)
    story = Stories.get_story!(story_id)

    nodes = story.nodes |> Enum.filter(&(&1.id != node.id))

    socket =
      socket
      |> assign(:page_title, node.title)
      |> assign(:node, node)
      |> assign(:nodes, nodes)
      |> assign_form(Stories.change_node(node), :form)
      |> assign_form(
        Stories.change_choice(%Stories.Choice{
          choice_targets: [%Stories.ChoiceTarget{}]
        }),
        :choice_form
      )

    if connected?(socket) do
      {:ok, push_event(socket, "initialize_editor", %{data: node.body})}
    else
      {:ok, socket}
    end
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new_choice, _) do
    socket
    |> assign(:page_title, "New Choice")
  end

  defp apply_action(socket, _, _) do
    socket
  end

  def render(assigns) do
    ~H"""
    <AdventurerWeb.PageHeader.render title={@page_title} />
    <div class="grid grid-cols-2 gap-8">
      <div>
        <AdventurerWeb.NodeLive.NodeForm.render form={@form} />
      </div>
      <div>
        <h2 class="text-lg mb-4">Choices</h2>
        <.link navigate={~p"/my/stories/#{@node.story_id}/nodes/#{@node.id}/choices/new"}>
          + Add Choice
        </.link>
        <ul>
          <%= for choice <- @node.choices do %>
            <li class="border grid grid-cols-3 gap-4 rounded-lg px-2 py-1.5 text-center">
              <div><%= choice.description %></div>
              <span>→</span>
              <div><%= target_node_title(choice) %></div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    <.modal
      :if={@live_action == :new_choice}
      id="choice-modal"
      show
      on_cancel={JS.patch(~p"/my/stories/#{@node.story_id}/nodes/#{@node.id}")}
    >
      <AdventurerWeb.NodeLive.ChoiceForm.render form={@choice_form} nodes={@nodes} node_id={@node.id} />
    </.modal>
    """
  end

  def handle_event("save", %{"node" => params}, socket) do
    {:noreply,
     socket
     |> assign(:params, params)
     |> push_event("save_editor", %{})}
  end

  def handle_event("save_node", %{"data" => body}, socket) do
    params = socket.assigns.params
    params = Map.put(params, "body", body)

    node = socket.assigns.node

    case Stories.update_node(node, params) do
      {:ok, node} ->
        {:noreply,
         socket
         |> put_flash(:info, "Node saved successfully")
         |> assign(:node, node)}

      {:error, changeset} ->
        {:error, to_form(changeset)}
    end
  end

  def handle_event("save_choice", %{"choice" => params}, socket) do
    case Stories.create_choice(params) |> dbg do
      {:ok, choice} ->
        node = Stories.get_node!(choice.node_id)

        {:noreply,
         socket
         |> put_flash(:info, "Choice created successfully")
         |> assign(:node, node)
         |> push_patch(to: ~p"/my/stories/#{node.story_id}/nodes/#{node.id}")}

      {:error, changeset} ->
        {:error, to_form(changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset, assign) do
    assign(socket, assign, to_form(changeset))
  end

  defp target_node_title(choice) do
    node = Adventurer.Choices.target_node(choice)
    node.title
  end
end
