defmodule PortfolioRebalancer.Repo do
  use Ecto.Repo,
    otp_app: :portfolio_rebalancer,
    adapter: Ecto.Adapters.Postgres
end
