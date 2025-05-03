defmodule PortfolioRebalancerWeb.ChatController do
  use PortfolioRebalancerWeb, :controller
  use OpenApiSpex.ControllerSpecs

  operation(:create_chat,
    summary: "Create a chat message",
    request_body:
      {"Chat message", "application/json",
       %OpenApiSpex.Schema{
         type: :object,
         properties: %{
           message: %OpenApiSpex.Schema{type: :string, description: "The message to send"}
         },
         required: [:message]
       }},
    responses: [
      ok: {"Chat response", "application/json", PortfolioRebalancerWeb.Schemas.ChatResponse}
    ]
  )

  @doc """
  Processes a chat message and returns a hardcoded AI response,
  along with updated profile and portfolio.
  """
  def create_chat(conn, %{"message" => _message}) do
    response = %{
      response:
        "I've adjusted your portfolio to reduce stock exposure from 60% to 40%, increasing bonds from 30% to 50%. This makes your profile more conservative. Your expected annual return is now 4.2% instead of 5.3%.",
      updatedProfile: %{
        userId: "550e8400-e29b-41d4-a716-446655440000",
        riskBucket: "Conservative",
        riskScore: 0.42,
        lastUpdated: Date.utc_today() |> Date.to_string()
      },
      updatedPortfolio: %{
        userId: "550e8400-e29b-41d4-a716-446655440000",
        totalBalance: 10000.00,
        rebalanceFrequencyDays: 90,
        assets: [
          %{
            symbol: "VTI",
            name: "Vanguard Total Stock Market ETF",
            assetClass: "Equity",
            weight: 0.40,
            currentPrice: 235.45,
            units: 16.99,
            currency: "USD",
            market: "US",
            priceDate: Date.utc_today() |> Date.to_string(),
            expectedYield: 0.068
          },
          %{
            symbol: "BND",
            name: "Vanguard Total Bond Market ETF",
            assetClass: "Bond",
            weight: 0.50,
            currentPrice: 72.35,
            units: 69.11,
            currency: "USD",
            market: "US",
            priceDate: Date.utc_today() |> Date.to_string(),
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
            priceDate: Date.utc_today() |> Date.to_string(),
            expectedYield: 0.015
          }
        ],
        lastUpdated: Date.utc_today() |> Date.to_string()
      }
    }

    json(conn, response)
  end

  def create(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{message: "Invalid message format"})
  end
end
