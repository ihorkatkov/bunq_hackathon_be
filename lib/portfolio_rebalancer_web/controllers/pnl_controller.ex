defmodule PortfolioRebalancerWeb.PnlController do
  use PortfolioRebalancerWeb, :controller
  use OpenApiSpex.ControllerSpecs

  operation(:get_pnl,
    tags: ["PnL"],
    summary: "Get PnL",
    description: "Get PnL for a given portfolio",
    operationId: "PnlController.get_pnl",
    responses: [
      ok: {"PnL retrieved successfully", "application/json", PortfolioRebalancerWeb.Schemas.Pnl}
    ]
  )

  def get_pnl(conn, _params) do
    json(conn, PortfolioRebalancer.Orchestrator.get_pnl())
  end
end
