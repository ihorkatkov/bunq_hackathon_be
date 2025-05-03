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
    profile = %{
      userId: "550e8400-e29b-41d4-a716-446655440000",
      riskBucket: "Balanced",
      riskScore: 0.65,
      lastUpdated: "2023-04-12T15:30:45Z"
    }

    json(conn, profile)
  end
end
