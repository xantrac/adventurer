defmodule Adventurer.Repo do
  use Ecto.Repo,
    otp_app: :adventurer,
    adapter: Ecto.Adapters.Postgres
end
