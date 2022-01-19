defmodule TodoJsonApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TodoJsonApi.Repo,
      # Start the Telemetry supervisor
      TodoJsonApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TodoJsonApi.PubSub},
      # Start the Endpoint (http/https)
      TodoJsonApiWeb.Endpoint
      # Start a worker by calling: TodoJsonApi.Worker.start_link(arg)
      # {TodoJsonApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TodoJsonApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TodoJsonApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
