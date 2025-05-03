defmodule PortfolioRebalancerWeb.Schemas.Pnl do
  @moduledoc """
  Schema for PnL
  """
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Pnl",
    description: "PnL for a given portfolio",
    type: :object,
    properties: %{
      date: %Schema{type: :string, description: "Date of the PnL", format: :date},
      balance: %Schema{type: :number, description: "Balance of the portfolio", format: :float},
      netReturn: %Schema{
        type: :number,
        description: "Net return of the portfolio",
        format: :float
      }
    },
    required: [:date, :balance, :netReturn],
    example: %{
      "date" => "2026-05-02",
      "balance" => 12450.20,
      "netReturn" => 0.087
    }
  })
end
