defmodule Adventurer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AdventurerWeb.Telemetry,
      # Start the Ecto repository
      Adventurer.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Adventurer.PubSub},
      # Start Finch
      {Finch, name: Adventurer.Finch},
      # Start the Endpoint (http/https)
      AdventurerWeb.Endpoint
      # Start a worker by calling: Adventurer.Worker.start_link(arg)
      # {Adventurer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Adventurer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AdventurerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
