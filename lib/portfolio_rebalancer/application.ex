defmodule PortfolioRebalancer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PortfolioRebalancerWeb.Telemetry,
      PortfolioRebalancer.Repo,
      {DNSCluster,
       query: Application.get_env(:portfolio_rebalancer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PortfolioRebalancer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PortfolioRebalancer.Finch},
      # Start a worker by calling: PortfolioRebalancer.Worker.start_link(arg)
      # {PortfolioRebalancer.Worker, arg},
      # Start to serve requests, typically the last entry
      PortfolioRebalancer.Orchestrator,
      PortfolioRebalancerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PortfolioRebalancer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PortfolioRebalancerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
