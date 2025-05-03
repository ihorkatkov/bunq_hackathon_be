defmodule PortfolioRebalancerWeb.Schemas.ErrorResponse do
  @moduledoc """
  Schema for standard error responses
  """
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "ErrorResponse",
    description: "Response schema for errors",
    type: :object,
    properties: %{
      message: %Schema{type: :string, description: "Human-readable error message"}
    },
    required: [:message],
    example: %{
      "message" => "Invalid API key"
    }
  })
end
