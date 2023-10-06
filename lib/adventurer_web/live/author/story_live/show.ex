defmodule AdventurerWeb.Author.StoryLive.Show do
  use AdventurerWeb, :live_view

  alias Adventurer.Stories

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    user = socket.assigns.current_user
    story = Stories.get_story!(id, user)

    socket
    |> assign(:page_title, story.title)
    |> assign(:story, story)
    |> assign(:form_action, :update)
    |> assign_form(Stories.change_story(story, %{}))
  end

  defp apply_action(socket, :preview, %{"node_id" => current_node_id}) do
    story = socket.assigns.story

    current_node = Enum.find(story.nodes, fn node -> node.id == current_node_id end)

    socket
    |> assign(:current_node, current_node)
  end

  defp apply_action(socket, _, _), do: socket

  @impl true
  def render(assigns) do
    ~H"""
    <AdventurerWeb.PageHeader.render {assigns}>
      <span class="sm:ml-3">
        <.link href={~p"/my/stories/#{@story.id}/nodes"}>
          <button
            type="button"
            class="inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50"
          >
            <svg
              class="-ml-0.5 mr-1.5 h-5 w-5 text-gray-400"
              viewBox="0 0 20 20"
              fill="currentColor"
              aria-hidden="true"
            >
              <path d="M12.232 4.232a2.5 2.5 0 013.536 3.536l-1.225 1.224a.75.75 0 001.061 1.06l1.224-1.224a4 4 0 00-5.656-5.656l-3 3a4 4 0 00.225 5.865.75.75 0 00.977-1.138 2.5 2.5 0 01-.142-3.667l3-3z" />
              <path d="M11.603 7.963a.75.75 0 00-.977 1.138 2.5 2.5 0 01.142 3.667l-3 3a2.5 2.5 0 01-3.536-3.536l1.225-1.224a.75.75 0 00-1.061-1.06l-1.224 1.224a4 4 0 105.656 5.656l3-3a4 4 0 00-.225-5.865z" />
            </svg>
            Node editor
          </button>
        </.link>
      </span>
      <span class="ml-3 hidden sm:block">
        <%= if @story.starting_node_id  do %>
          <.link patch={~p"/my/stories/#{@story.id}/preview/nodes/#{@story.starting_node_id}"}>
            <button
              type="button"
              class="inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50"
            >
              <svg
                class="-ml-0.5 mr-1.5 h-5 w-5 text-gray-400"
                viewBox="0 0 20 20"
                fill="currentColor"
                aria-hidden="true"
              >
                <path d="M12.232 4.232a2.5 2.5 0 013.536 3.536l-1.225 1.224a.75.75 0 001.061 1.06l1.224-1.224a4 4 0 00-5.656-5.656l-3 3a4 4 0 00.225 5.865.75.75 0 00.977-1.138 2.5 2.5 0 01-.142-3.667l3-3z" />
                <path d="M11.603 7.963a.75.75 0 00-.977 1.138 2.5 2.5 0 01.142 3.667l-3 3a2.5 2.5 0 01-3.536-3.536l1.225-1.224a.75.75 0 00-1.061-1.06l-1.224 1.224a4 4 0 105.656 5.656l3-3a4 4 0 00-.225-5.865z" />
              </svg>
              Preview
            </button>
          </.link>
        <% end %>
      </span>

      <span class="sm:ml-3">
        <.button icon="hero-">Publish</.button>
      </span>
    </AdventurerWeb.PageHeader.render>
    <div>
      <.simple_form for={@form} id="story-form" phx-submit={@form_action}>
        <div class="col-span-full">
          <.input field={@form[:title]} type="text" label="Title" />
        </div>
        <div class="col-span-full">
          <.input field={@form[:description]} type="textarea" label="Description" />
        </div>
        <div class="sm:col-span-3">
          <.input
            field={@form[:starting_node_id]}
            type="select"
            label="Initial node"
            options={nodes_options(@story)}
          />
        </div>
        <div class="sm:col-span-3">
          <.input field={@form[:cover_image_url]} type="url" label="Cover image URL" />
        </div>
        <:actions>
          <.button phx-disable-with="Saving...">Save Story</.button>
        </:actions>
      </.simple_form>
    </div>
    <.modal
      :if={@live_action == :preview}
      id="preview-modal"
      show
      on_cancel={JS.patch(~p"/my/stories/#{@story.id}")}
    >
      <AdventurerWeb.Preview.render story={@story} current_node={@current_node} />
    </.modal>
    """
  end

  @impl true
  def handle_event("update", %{"story" => story_params}, socket) do
    story = socket.assigns.story

    case Stories.update_story(story, story_params) do
      {:ok, story} ->
        {:noreply,
         socket
         |> put_flash(:info, "Story updated successfully.")
         |> assign(:story, story)
         |> assign_form(Stories.change_story(story, %{}))}

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("create", %{"story" => story_params}, socket) do
    current_user = socket.assigns.current_user
    story_params = Map.put(story_params, "user_id", current_user.id)

    case Stories.create_story(story_params) |> dbg do
      {:ok, story} ->
        {:noreply,
         socket
         |> put_flash(:info, "Story created successfully.")
         |> push_patch(to: ~p"/my/stories/#{story.id}")}

      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error creating story.")
         |> assign_form(changeset)}
    end
  end

  def handle_event("publish", _, socket) do
    story = socket.assigns.story

    case Stories.publish_story(story) do
      {:ok, story} ->
        {:noreply,
         socket
         |> put_flash(:info, "Story published successfully.")
         |> assign(:story, story)
         |> assign_form(Stories.change_story(story, %{}))}

      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error publishing story.")
         |> assign_form(changeset)}
    end
  end

  defp nodes_options(story) do
    Enum.map(story.nodes, &{&1.title, &1.id})
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
