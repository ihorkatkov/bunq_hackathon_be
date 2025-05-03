defmodule PortfolioRebalancerWeb.Router do
  use PortfolioRebalancerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: PortfolioRebalancerWeb.ApiSpec
  end

  # API v1 routes, require JSON and API key authentication
  scope "/api/v1", PortfolioRebalancerWeb do
    pipe_through [:api]

    # Profile Management
    get "/investor-profile", InvestorProfileController, :show_investor_profile

    # Portfolio Management
    get "/portfolio", PortfolioController, :show_portfolio

    # Chat Interface
    post "/chat", ChatController, :create_chat

    # User Profile
    get "/me", UserProfileController, :show_user_profile
  end

  scope "/" do
    pipe_through :api

    # Serve the spec
    get "/api/openapi", OpenApiSpex.Plug.RenderSpec, []
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:portfolio_rebalancer, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: PortfolioRebalancerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
