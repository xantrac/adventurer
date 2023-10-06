defmodule AdventurerWeb.LayoutComponents do
  use AdventurerWeb, :component

  def desktop_nav(assigns) do
    ~H"""
    <%= for link <- @nav_links do %>
      <.link navigate={~p"/#{link}"}>
        <%= String.capitalize(link) %>
      </.link>
    <% end %>
    """
  end

  attr :user, :any, required: true

  def user_logo(assigns) do
    ~H"""
    <div class="-m-1.5 p-1.5">
      <span class="sr-only">Your profile</span>
      <div class="border border-gray-500 text-gray-500 rounded-full p-1">
        <.link navigate={~p"/users/settings"}>
          <%= get_user_initials(@user) %>
        </.link>
      </div>
    </div>
    """
  end

  attr :user, :any, required: true

  def mobile_drawer(assigns) do
    ~H"""
    <div class="hidden" role="dialog" aria-modal="true" id="mobile-drawer">
      <div class="fixed inset-0 z-50"></div>
      <div class="fixed inset-y-0 left-0 z-50 w-full overflow-y-auto bg-white px-4 pb-6 sm:max-w-sm sm:px-6 sm:ring-1 sm:ring-gray-900/10">
        <div class="-ml-0.5 flex h-16 items-center gap-x-6">
          <button type="button" class="-m-2.5 p-2.5 text-gray-700" phx-click={hide_drawer()}>
            <span class="sr-only">Close menu</span>
            <svg
              class="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              aria-hidden="true"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
          <div class="-ml-0.5">
            <.link navigate={~p"/"}>
              <div class="flex items-center">
                <span class="font-ubuntu text-2xl text-gray-900">MarryMeThere</span>
              </div>
            </.link>
          </div>
        </div>
        <div class="mt-2 space-y-2">
          <a
            href="#"
            class="-mx-3 block rounded-lg px-3 py-2 text-base font-semibold leading-7 text-gray-900 hover:bg-gray-50"
          >
            Home
          </a>
          <a
            href="#"
            class="-mx-3 block rounded-lg px-3 py-2 text-base font-semibold leading-7 text-gray-900 hover:bg-gray-50"
          >
            Invoices
          </a>
          <a
            href="#"
            class="-mx-3 block rounded-lg px-3 py-2 text-base font-semibold leading-7 text-gray-900 hover:bg-gray-50"
          >
            Clients
          </a>
          <a
            href="#"
            class="-mx-3 block rounded-lg px-3 py-2 text-base font-semibold leading-7 text-gray-900 hover:bg-gray-50"
          >
            Expenses
          </a>
        </div>
      </div>
    </div>
    """
  end

  def show_drawer(js \\ %JS{}) do
    js
    |> JS.show(transition: "fade-in", to: "#mobile-drawer")
  end

  def hide_drawer(js \\ %JS{}) do
    js
    |> JS.hide(transition: "fade-out", to: "#mobile-drawer")
  end

  def get_user_initials(%{first_name: first_name, last_name: last_name}) do
    first = String.at(first_name, 0)
    last = String.at(last_name, 0)

    "#{first}#{last}"
  end
end
