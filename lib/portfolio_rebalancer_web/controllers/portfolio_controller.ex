defmodule PortfolioRebalancerWeb.PortfolioController do
  use PortfolioRebalancerWeb, :controller
  use OpenApiSpex.ControllerSpecs

  operation(:show_portfolio,
    summary: "Show portfolio",
    parameters: [],
    responses: [
      ok: {"Portfolio response", "application/json", PortfolioRebalancerWeb.Schemas.Portfolio}
    ]
  )

  @doc """
  Returns a hardcoded portfolio recommendation.
  """
  def show_portfolio(conn, _params) do
    portfolio = %{
      userId: "550e8400-e29b-41d4-a716-446655440000",
      totalBalance: PortfolioRebalancer.Orchestrator.get_balance(),
      rebalanceFrequencyDays: 30,
      assets: [
        %{
          symbol: "VTI",
          name: "Vanguard Total Stock Market ETF",
          assetClass: "Equity",
          weight: 0.60,
          currentPrice: 235.45,
          units: 25.48,
          currency: "USD",
          market: "US",
          priceDate: "2023-04-12",
          expectedYield: 0.068
        },
        %{
          symbol: "BND",
          name: "Vanguard Total Bond Market ETF",
          assetClass: "Bond",
          weight: 0.30,
          currentPrice: 72.35,
          units: 41.46,
          currency: "USD",
          market: "US",
          priceDate: "2023-04-12",
          expectedYield: 0.042
        },
        %{
          symbol: "GLD",
          name: "SPDR Gold Shares",
          assetClass: "Commodity",
          weight: 0.10,
          currentPrice: 184.90,
          units: 5.41,
          currency: "USD",
          market: "US",
          priceDate: "2023-04-12",
          expectedYield: 0.015
        }
      ],
      lastUpdated: "2023-04-12T15:30:45Z"
    }

    json(conn, portfolio)
  end
end
