defmodule PortfolioRebalancerWeb.Schemas.InvestorProfile do
  @moduledoc """
  Schema for investor profile
  """
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "InvestorProfile",
    description: "Investor risk profile",
    type: :object,
    properties: %{
      userId: %Schema{type: :string, format: :uuid, description: "Unique identifier for the user"},
      riskBucket: %Schema{
        type: :string,
        description: "Risk profile category",
        enum: ["Conservative", "Balanced", "Growth", "Aggressive"]
      },
      riskScore: %Schema{
        type: :number,
        format: :float,
        description: "Numerical risk score from 0.0 (risk-averse) to 1.0 (risk-seeking)"
      },
      lastUpdated: %Schema{
        type: :string,
        format: :"date-time",
        description: "Timestamp of last profile update"
      }
    },
    required: [:userId, :riskBucket, :riskScore, :lastUpdated],
    example: %{
      "userId" => "550e8400-e29b-41d4-a716-446655440000",
      "riskBucket" => "Balanced",
      "riskScore" => 0.65,
      "lastUpdated" => "2023-04-12T15:30:45Z"
    }
  })
end
