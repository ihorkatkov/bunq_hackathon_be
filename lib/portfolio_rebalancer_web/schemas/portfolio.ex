defmodule PortfolioRebalancerWeb.Schemas.Portfolio do
  @moduledoc """
  Schema for investment portfolio
  """
  require OpenApiSpex
  alias OpenApiSpex.Schema
  alias PortfolioRebalancerWeb.Schemas.Asset

  OpenApiSpex.schema(%{
    title: "Portfolio",
    description: "Investment portfolio with assets allocation",
    type: :object,
    properties: %{
      userId: %Schema{type: :string, format: :uuid, description: "Unique identifier for the user"},
      totalBalance: %Schema{
        type: :number,
        format: :float,
        description: "Total portfolio value in base currency"
      },
      rebalanceFrequencyDays: %Schema{
        type: :integer,
        description: "Recommended rebalance frequency in days"
      },
      assets: %Schema{
        type: :array,
        items: Asset,
        description: "List of assets in the portfolio"
      },
      lastUpdated: %Schema{
        type: :string,
        format: :"date-time",
        description: "Timestamp of last portfolio update"
      }
    },
    required: [:userId, :totalBalance, :rebalanceFrequencyDays, :assets, :lastUpdated],
    example: %{
      "userId" => "550e8400-e29b-41d4-a716-446655440000",
      "totalBalance" => 10000.00,
      "rebalanceFrequencyDays" => 90,
      "assets" => [
        %{
          "symbol" => "VTI",
          "name" => "Vanguard Total Stock Market ETF",
          "assetClass" => "Equity",
          "weight" => 0.60,
          "currentPrice" => 235.45,
          "units" => 25.48,
          "currency" => "USD",
          "market" => "US",
          "priceDate" => "2023-04-12",
          "expectedYield" => 0.068
        },
        %{
          "symbol" => "BND",
          "name" => "Vanguard Total Bond Market ETF",
          "assetClass" => "Bond",
          "weight" => 0.30,
          "currentPrice" => 72.35,
          "units" => 41.46,
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
      "lastUpdated" => "2023-04-12T15:30:45Z"
    }
  })
end
