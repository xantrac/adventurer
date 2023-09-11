defmodule AdventurerWeb.NodeLive.NodeForm do
  use AdventurerWeb, :component

  attr :form, :any, required: true

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-submit="save" class="">
        <div class="flex-1">
          <.input type="text" field={@form[:title]} />
        </div>
        <div id="node-page" class="pt-4 " phx-hook="EditorJS">
          <div id="editor" phx-update="ignore">
            <div class="border overflow-scroll h-72 rounded-lg p-4" id="editorjs"></div>
          </div>
        </div>
        <.button phx-disable-with="Saving...">Save</.button>
      </.form>
    </div>
    """
  end
end
