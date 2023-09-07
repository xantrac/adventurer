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
    <header class="pb-4 pt-6 sm:pb-6">
      <div class="mx-auto flex max-w-7xl flex-wrap items-center gap-6 px-4 sm:flex-nowrap sm:px-6 lg:px-8">
        <h1 class="text-base font-semibold leading-7 text-gray-900">Cashflow</h1>
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
    </header>
    <div class="grid sm:grid-cols-2 gap-8">
      <div>
        <h2 class="text-base font-semibold leading-7 text-gray-900">Details</h2>
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
        <h2 class="text-base font-semibold leading-7 text-gray-900">Nodes</h2>
      </div>
    </div>
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
