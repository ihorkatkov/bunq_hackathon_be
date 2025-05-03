defmodule PortfolioRebalancerWeb.Schemas.Asset do
  @moduledoc """
  Schema for investment portfolio asset
  """
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Asset",
    description: "Investment asset in a portfolio",
    type: :object,
    properties: %{
      symbol: %Schema{type: :string, description: "Asset ticker symbol"},
      name: %Schema{type: :string, description: "Full name of the asset"},
      assetClass: %Schema{
        type: :string,
        description: "Asset class category",
        enum: ["Equity", "Bond", "Commodity", "Cash", "Real Estate"]
      },
      weight: %Schema{
        type: :number,
        format: :float,
        description: "Portfolio allocation weight (0.0-1.0)"
      },
      currentPrice: %Schema{type: :number, format: :float, description: "Current market price"},
      units: %Schema{type: :number, format: :float, description: "Number of units held"},
      currency: %Schema{type: :string, description: "Price currency", example: "USD"},
      market: %Schema{
        type: :string,
        description: "Market where the asset is traded",
        example: "US"
      },
      priceDate: %Schema{type: :string, format: :date, description: "Date of current price"},
      expectedYield: %Schema{type: :number, format: :float, description: "Expected annual yield"}
    },
    required: [
      :symbol,
      :name,
      :assetClass,
      :weight,
      :currentPrice,
      :units,
      :currency,
      :market,
      :priceDate,
      :expectedYield
    ],
    example: %{
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
    }
  })
end
