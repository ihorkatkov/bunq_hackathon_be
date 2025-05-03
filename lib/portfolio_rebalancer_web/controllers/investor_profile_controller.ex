defmodule PortfolioRebalancerWeb.InvestorProfileController do
  use PortfolioRebalancerWeb, :controller
  use OpenApiSpex.ControllerSpecs

  operation(:show_investor_profile,
    summary: "Show investor profile",
    parameters: [],
    responses: [
      ok:
        {"Investor profile response", "application/json",
         PortfolioRebalancerWeb.Schemas.InvestorProfile}
    ]
  )

  @doc """
  Returns a hardcoded investor profile.
  """
  def show_investor_profile(conn, _params) do
    %{
      "risk_profile" => risk_profile,
      "risk_score" => risk_score
    } = PortfolioRebalancer.Orchestrator.get_investment_profile()

    profile = %{
      userId: "550e8400-e29b-41d4-a716-446655440000",
      riskBucket: risk_profile,
      riskScore: risk_score,
      lastUpdated: Date.utc_today() |> Date.to_string()
    }

    json(conn, profile)
  end
end
