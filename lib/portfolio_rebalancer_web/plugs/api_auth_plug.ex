defmodule PortfolioRebalancerWeb.Plugs.ApiAuthPlug do
  @moduledoc """
  Plug for API authentication via API key
  """
  import Plug.Conn
  require Logger

  @api_key_header "x-api-key"
  # Hardcoded API key for demonstration purposes
  @valid_api_key "demo-api-key-12345"

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, @api_key_header) do
      [api_key] when api_key == @valid_api_key ->
        # Authenticated
        conn

      [_invalid_key] ->
        # Invalid API key
        handle_unauthorized(conn, "Invalid API key")

      [] ->
        # Missing API key
        handle_unauthorized(conn, "Missing API key")
    end
  end

  defp handle_unauthorized(conn, message) do
    Logger.warning("API authentication failed: #{message}")

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{message: message}))
    |> halt()
  end
end
