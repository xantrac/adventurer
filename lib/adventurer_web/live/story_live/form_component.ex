defmodule AdventurerWeb.StoryLive.FormComponent do
  use AdventurerWeb, :live_component

  alias Adventurer.Stories

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Create a new story</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="story-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Story</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{story: story} = assigns, socket) do
    changeset = Stories.change_story(story)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"story" => story_params}, socket) do
    changeset =
      socket.assigns.story
      |> Stories.change_story(story_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"story" => story_params}, socket) do
    save_story(socket, socket.assigns.action, story_params)
  end

  defp save_story(socket, :edit, story_params) do
    case Stories.update_story(socket.assigns.story, story_params) do
      {:ok, story} ->
        notify_parent({:saved, story})

        {:noreply,
         socket
         |> put_flash(:info, "Story updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_story(socket, :new, story_params) do
    current_user = socket.assigns.user

    case Stories.create_story(story_params, current_user) do
      {:ok, story} ->
        notify_parent({:saved, story})

        {:noreply,
         socket
         |> put_flash(:info, "Story created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
