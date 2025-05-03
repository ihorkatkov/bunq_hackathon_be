defmodule PortfolioRebalancerWeb.UserProfileController do
  use PortfolioRebalancerWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias PortfolioRebalancerWeb.Schemas.UserProfile

  operation(:show_user_profile,
    tags: ["Profile Management"],
    summary: "Get user profile",
    description: "Returns basic user information (first name, last name).",
    operationId: "UserProfileController.show",
    parameters: [],
    responses: [
      ok: {"User profile retrieved successfully", "application/json", UserProfile}
    ]
  )

  def show_user_profile(conn, _params) do
    # In a real application, you would fetch the user data based on the
    # authenticated user information stored in the connection (e.g., conn.assigns.current_user)
    user_profile = %{
      # Replace with actual data
      firstName: "John",
      # Replace with actual data
      lastName: "Doe"
    }

    json(conn, user_profile)
  end
end
