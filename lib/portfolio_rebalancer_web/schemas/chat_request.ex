defmodule PortfolioRebalancerWeb.Schemas.ChatRequest do
  @moduledoc """
  Schema for chat request
  """
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "ChatRequest",
    description: "Request to the AI chat interface",
    type: :object,
    properties: %{
      message: %Schema{type: :string, description: "User message to process", minLength: 1}
    },
    required: [:message],
    example: %{
      "message" => "I'd like to reduce my exposure to stocks"
    }
  })
end
