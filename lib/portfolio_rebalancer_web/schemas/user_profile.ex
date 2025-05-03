defmodule PortfolioRebalancerWeb.Schemas.UserProfile do
  @moduledoc """
  Schema for basic user profile information
  """
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "UserProfile",
    description: "Basic user profile information",
    type: :object,
    properties: %{
      firstName: %Schema{type: :string, description: "User's first name"},
      lastName: %Schema{type: :string, description: "User's last name"}
    },
    required: [:firstName, :lastName],
    example: %{
      "firstName" => "John",
      "lastName" => "Doe"
    }
  })
end
