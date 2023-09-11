defmodule AdventurerWeb.Author.StoryLive.Show do
  use AdventurerWeb, :live_view

  alias Adventurer.Stories

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    story = Stories.get_story!(id)

    {:noreply,
     socket
     |> assign(:page_title, story.title)
     |> assign(:story, story)
     |> assign_form(Stories.change_story(story, %{}))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <AdventurerWeb.PageHeader.render title={@page_title}>
      <span class="ml-3 hidden sm:block">
        <.link patch={~p"/my/stories/#{@story.id}/preview"}>
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
      </span>

      <span class="sm:ml-3">
        <button
          type="button"
          class="inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        >
          <svg
            class="-ml-0.5 mr-1.5 h-5 w-5"
            viewBox="0 0 20 20"
            fill="currentColor"
            aria-hidden="true"
          >
            <path
              fill-rule="evenodd"
              d="M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.05-.143z"
              clip-rule="evenodd"
            />
          </svg>
          Publish
        </button>
      </span>
    </AdventurerWeb.PageHeader.render>
    <div class="grid sm:grid-cols-2 gap-8">
      <div>
        <.simple_form for={@form} id="story-form" phx-submit="save">
          <div class="col-span-full">
            <.input field={@form[:title]} type="text" label="Title" />
          </div>
          <div class="col-span-full">
            <.input field={@form[:description]} type="textarea" label="Description" />
          </div>
          <:actions>
            <.button phx-disable-with="Saving...">Save Story</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <div class="flex justify-between items-center mt-6">
          <h2 class="block text-sm font-medium leading-6 text-gray-900">Nodes</h2>
          <.link
            patch={~p"/my/stories/#{@story.id}/nodes/new"}
            class="ml-auto flex items-center gap-x-1 rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
          >
            <svg class="-ml-1.5 h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path d="M10.75 6.75a.75.75 0 00-1.5 0v2.5h-2.5a.75.75 0 000 1.5h2.5v2.5a.75.75 0 001.5 0v-2.5h2.5a.75.75 0 000-1.5h-2.5v-2.5z" />
            </svg>
            New Node
          </.link>
        </div>
        <ul role="list" class="grid grid-cols-1 gap-6 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
          <%= for node <- @story.nodes do %>
            <li class="col-span-1 flex flex-col divide-y divide-gray-200 rounded-lg bg-white text-center shadow">
              <.link patch={~p"/my/stories/#{@story.id}/nodes/#{node.id}"}>
                <div class="flex flex-1 flex-col p-8">
                  <h3 class="mt-6 text-sm font-medium text-gray-900"><%= node.title %></h3>
                  <dl class="mt-1 flex flex-grow flex-col justify-between">
                    <dt class="sr-only"><%= node.title %></dt>
                  </dl>
                </div>
              </.link>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    <.modal
      :if={@live_action == :preview}
      id="preview-modal"
      show
      on_cancel={JS.patch(~p"/my/stories/#{@story.id}")}
    >
      WHAT
    </.modal>
    """
  end

  @impl true
  def handle_event("save", %{"story" => story_params}, socket) do
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

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
