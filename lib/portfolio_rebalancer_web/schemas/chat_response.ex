defmodule PortfolioRebalancerWeb.Schemas.ChatResponse do
  @moduledoc """
  Schema for chat response
  """
  require OpenApiSpex
  alias OpenApiSpex.Schema
  alias PortfolioRebalancerWeb.Schemas.{InvestorProfile, Portfolio}

  OpenApiSpex.schema(%{
    title: "ChatResponse",
    description: "Response from the AI chat interface",
    type: :object,
    properties: %{
      response: %Schema{type: :string, description: "AI-generated response to the user message"},
      updatedProfile: InvestorProfile,
      updatedPortfolio: Portfolio
    },
    required: [:response, :updatedProfile, :updatedPortfolio],
    example: %{
      "response" =>
        "I've adjusted your portfolio to reduce stock exposure from 60% to 40%, increasing bonds from 30% to 50%. This makes your profile more conservative. Your expected annual return is now 4.2% instead of 5.3%.",
      "updatedProfile" => %{
        "userId" => "550e8400-e29b-41d4-a716-446655440000",
        "riskBucket" => "Conservative",
        "riskScore" => 0.42,
        "lastUpdated" => "2023-04-12T15:45:30Z"
      },
      "updatedPortfolio" => %{
        "userId" => "550e8400-e29b-41d4-a716-446655440000",
        "totalBalance" => 10000.00,
        "rebalanceFrequencyDays" => 90,
        "assets" => [
          %{
            "symbol" => "VTI",
            "name" => "Vanguard Total Stock Market ETF",
            "assetClass" => "Equity",
            "weight" => 0.40,
            "currentPrice" => 235.45,
            "units" => 16.99,
            "currency" => "USD",
            "market" => "US",
            "priceDate" => "2023-04-12",
            "expectedYield" => 0.068
          },
          %{
            "symbol" => "BND",
            "name" => "Vanguard Total Bond Market ETF",
            "assetClass" => "Bond",
            "weight" => 0.50,
            "currentPrice" => 72.35,
            "units" => 69.11,
            "currency" => "USD",
            "market" => "US",
            "priceDate" => "2023-04-12",
            "expectedYield" => 0.042
          },
          %{
            "symbol" => "GLD",
            "name" => "SPDR Gold Shares",
            "assetClass" => "Commodity",
            "weight" => 0.10,
            "currentPrice" => 184.90,
            "units" => 5.41,
            "currency" => "USD",
            "market" => "US",
            "priceDate" => "2023-04-12",
            "expectedYield" => 0.015
          }
        ],
        "lastUpdated" => "2023-04-12T15:45:30Z"
      }
    }
  })
end
