defmodule AdventurerWeb.PageHeader do
  use AdventurerWeb, :component

  attr :page_title, :string, required: true
  slot :inner_block

  def render(assigns) do
    ~H"""
    <div class="lg:flex lg:items-center lg:justify-between pt-4">
      <div class="min-w-0 flex-1">
        <AdventurerWeb.BreadCrumbs.render {assigns} />
        <h2 class="mt-2 text-2xl font-bold leading-7 text-gray-900 sm:truncate sm:text-3xl sm:tracking-tight">
          <%= @page_title %>
        </h2>
      </div>
      <div class="mt-5 flex lg:ml-4 lg:mt-0">
        <%= render_slot(@inner_block) %>
        <!-- Dropdown -->
        <div class="relative ml-3 sm:hidden">
          <button
            type="button"
            class="inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:ring-gray-400"
            id="mobile-menu-button"
            aria-expanded="false"
            aria-haspopup="true"
          >
            More
            <svg
              class="-mr-1 ml-1.5 h-5 w-5 text-gray-400"
              viewBox="0 0 20 20"
              fill="currentColor"
              aria-hidden="true"
            >
              <path
                fill-rule="evenodd"
                d="M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z"
                clip-rule="evenodd"
              />
            </svg>
          </button>
          <!--
            Dropdown menu, show/hide based on menu state.

            Entering: "transition ease-out duration-200"
              From: "transform opacity-0 scale-95"
              To: "transform opacity-100 scale-100"
            Leaving: "transition ease-in duration-75"
              From: "transform opacity-100 scale-100"
              To: "transform opacity-0 scale-95"
          -->
          <div
            class="absolute right-0 z-10 -mr-1 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none"
            role="menu"
            aria-orientation="vertical"
            aria-labelledby="mobile-menu-button"
            tabindex="-1"
          >
            <!-- Active: "bg-gray-100", Not Active: "" -->
            <a
              href="#"
              class="block px-4 py-2 text-sm text-gray-700"
              role="menuitem"
              tabindex="-1"
              id="mobile-menu-item-0"
            >
              Edit
            </a>
            <a
              href="#"
              class="block px-4 py-2 text-sm text-gray-700"
              role="menuitem"
              tabindex="-1"
              id="mobile-menu-item-1"
            >
              View
            </a>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
