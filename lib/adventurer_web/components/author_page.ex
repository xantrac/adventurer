defmodule AdventurerWeb.AuthorPage do
  use AdventurerWeb, :component

  slot :inner_block
  slot :header_buttons

  def render(assigns) do
    ~H"""
    <div>
      <AdventurerWeb.PageHeader.render {assigns}>
        <%= render_slot(@header_buttons) %>
      </AdventurerWeb.PageHeader.render>
      <div class="py-6">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
