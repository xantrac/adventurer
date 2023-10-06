defmodule Adventurer.Clients.Unsplash do
  use Tesla

  @client_id Application.get_env(:adventurer, :unsplash_client_id)

  plug Tesla.Middleware.BaseUrl, "https://api.unsplash.com/photos/"
  plug Tesla.Middleware.Headers, [{"authorization", "Client-ID #{@client_id}"}]
  plug Tesla.Middleware.JSON

  def get_random_image(search_terms) do
    {:ok, %{body: %{"urls" => %{"regular" => url}}}} = get("random", query: [query: search_terms])

    url
  end
end
