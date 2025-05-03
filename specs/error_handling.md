# Error Handling Specification

This document outlines the error handling strategy for the Bunq Investment Platform.

## Error Types

### API Errors
- **Client Errors** (4xx): Errors caused by incorrect client requests
- **Server Errors** (5xx): Errors in the application itself
- **External Service Errors**: Errors from Bunq API or LLM service

## Error Response Format

All API errors will be returned in a consistent JSON format:

```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "The requested resource could not be found",
    "details": {
      "resource": "portfolio",
      "id": "123e4567-e89b-12d3-a456-426614174000"
    },
    "request_id": "req_7h4k29d8s"
  }
}
```

## Error Codes

For the hackathon, we'll implement a basic set of error codes:

| HTTP Status | Error Code | Description |
|-------------|------------|-------------|
| 400 | INVALID_REQUEST | Request was invalid |
| 401 | UNAUTHORIZED | Invalid or missing API key |
| 403 | FORBIDDEN | Valid API key but insufficient permissions |
| 404 | RESOURCE_NOT_FOUND | Requested resource does not exist |
| 422 | VALIDATION_ERROR | Request validation failed |
| 429 | RATE_LIMITED | Too many requests |
| 500 | INTERNAL_ERROR | Server error |
| 502 | EXTERNAL_SERVICE_ERROR | Error from external service |
| 503 | SERVICE_UNAVAILABLE | Service temporarily unavailable |

## Implementation

### Phoenix Error View

```elixir
defmodule BunqInvestmentWeb.ErrorView do
  use BunqInvestmentWeb, :view

  # Error handlers for specific status codes
  
  def render("400.json", %{reason: reason}) do
    %{
      error: %{
        code: "INVALID_REQUEST",
        message: "The request was invalid",
        details: reason,
        request_id: get_request_id()
      }
    }
  end
  
  def render("401.json", _assigns) do
    %{
      error: %{
        code: "UNAUTHORIZED",
        message: "Invalid or missing API key",
        request_id: get_request_id()
      }
    }
  end
  
  def render("404.json", %{resource: resource, id: id}) do
    %{
      error: %{
        code: "RESOURCE_NOT_FOUND",
        message: "The requested resource could not be found",
        details: %{
          resource: resource,
          id: id
        },
        request_id: get_request_id()
      }
    }
  end
  
  def render("422.json", %{changeset: changeset}) do
    errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    
    %{
      error: %{
        code: "VALIDATION_ERROR",
        message: "Validation failed",
        details: %{errors: errors},
        request_id: get_request_id()
      }
    }
  end
  
  def render("500.json", _assigns) do
    %{
      error: %{
        code: "INTERNAL_ERROR",
        message: "An internal server error occurred",
        request_id: get_request_id()
      }
    }
  end
  
  def render("502.json", %{service: service}) do
    %{
      error: %{
        code: "EXTERNAL_SERVICE_ERROR",
        message: "Error communicating with external service",
        details: %{service: service},
        request_id: get_request_id()
      }
    }
  end
  
  # Fallback for all other error codes
  def render(status, _assigns) do
    %{
      error: %{
        code: "ERROR",
        message: "An error occurred",
        details: %{status: status},
        request_id: get_request_id()
      }
    }
  end
  
  defp get_request_id do
    Logger.metadata()[:request_id] || "unknown"
  end
  
  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
```

### Error Handling in Controllers

For the hackathon, we'll use Phoenix's built-in action_fallback mechanism with a centralized fallback controller:

```elixir
defmodule BunqInvestmentWeb.FallbackController do
  use BunqInvestmentWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BunqInvestmentWeb.ErrorView)
    |> render("422.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found, resource, id}) do
    conn
    |> put_status(:not_found)
    |> put_view(BunqInvestmentWeb.ErrorView)
    |> render("404.json", resource: resource, id: id)
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(BunqInvestmentWeb.ErrorView)
    |> render("401.json")
  end

  def call(conn, {:error, :external_service, service}) do
    conn
    |> put_status(:bad_gateway)
    |> put_view(BunqInvestmentWeb.ErrorView)
    |> render("502.json", service: service)
  end
  
  # Catch-all for other errors
  def call(conn, {:error, _reason}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(BunqInvestmentWeb.ErrorView)
    |> render("500.json")
  end
end
```

## Error Logging

Simple error logging strategy for the hackathon:

```elixir
defmodule BunqInvestment.ErrorReporter do
  require Logger
  
  def log_error(kind, error, stacktrace) do
    Logger.error("""
    Error type: #{kind}
    Error: #{inspect(error)}
    Stacktrace: #{inspect(stacktrace)}
    """)
  end
  
  def log_external_service_error(service, error) do
    Logger.error("""
    External service error from #{service}:
    #{inspect(error)}
    """)
  end
end
```

## Implementation Plan for Hackathon

1. Set up the basic ErrorView and FallbackController
2. Implement error handling for API endpoints
3. Add basic error logging
4. Implement error handling for LLM service calls

For the hackathon, detailed error tracking, metrics, and sophisticated retry mechanisms can be omitted to save time. 