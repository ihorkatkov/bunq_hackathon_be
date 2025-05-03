# Integration Requirements Specification

This document outlines the integration requirements for connecting the Bunq Investment Platform with external services.

## Bunq API Integration

### Purpose
- Fetch transaction data for users to analyze spending patterns
- Use transaction history to determine risk profile

### Requirements
- **Authentication**: Implement OAuth flow for Bunq API access
- **Endpoint Access**: Read-only access to transaction history
- **Data Retrieval**: Fetch transactions for a configurable time period (default: last 6 months)

### Implementation Approach
For the hackathon, we'll use a simplified approach:

```elixir
defmodule BunqInvestment.BunqAPI do
  @moduledoc """
  Client for interacting with the Bunq API.
  """
  
  # For hackathon, we'll simulate Bunq API responses
  def get_transactions(user_id, opts \\ []) do
    # In a real implementation, this would call the actual Bunq API
    # For the hackathon, we'll return simulated transaction data
    
    simulated_transactions = [
      %{
        id: "12345",
        amount: %{value: "-45.50", currency: "EUR"},
        description: "Groceries",
        counterparty_alias: %{display_name: "Supermarket"},
        created: "2023-04-01T10:15:30Z",
        type: "IDEAL"
      },
      %{
        id: "12346",
        amount: %{value: "2500.00", currency: "EUR"},
        description: "Salary April",
        counterparty_alias: %{display_name: "Employer Inc."},
        created: "2023-04-01T00:00:00Z",
        type: "TRANSFER"
      },
      # More simulated transactions...
    ]
    
    {:ok, simulated_transactions}
  end
  
  # Mock method to transform Bunq API response format to our internal format
  def transform_transactions(transactions) do
    Enum.map(transactions, fn tx ->
      %{
        bunq_id: tx.id,
        amount: parse_amount(tx.amount.value),
        description: tx.description,
        counterparty: tx.counterparty_alias.display_name,
        category: categorize_transaction(tx),
        transaction_date: parse_date(tx.created)
      }
    end)
  end
  
  defp parse_amount(value) do
    {amount, _} = Float.parse(value)
    amount
  end
  
  defp parse_date(datetime_string) do
    {:ok, datetime, _} = DateTime.from_iso8601(datetime_string)
    DateTime.to_date(datetime)
  end
  
  defp categorize_transaction(tx) do
    # Very basic categorization for the hackathon
    # In a real app, this would be much more sophisticated
    cond do
      String.contains?(String.downcase(tx.description), "salary") -> "income"
      String.contains?(String.downcase(tx.description), "groceries") -> "groceries"
      String.contains?(String.downcase(tx.description), "restaurant") -> "dining"
      true -> "other"
    end
  end
end
```

## LLM Integration

### Purpose
- Generate investment risk profiles based on transaction data
- Create portfolio recommendations based on risk profiles
- Power the chat interface for user interactions

### Requirements
- **API Access**: Access to an LLM API (OpenAI, Claude, etc.)
- **Prompt Engineering**: Templates for different use cases
- **Response Parsing**: Extract structured data from LLM responses

### Implementation Approach
For the hackathon, we'll implement a simplified LLM client:

```elixir
defmodule BunqInvestment.LLM.Client do
  @moduledoc """
  Client for interacting with the LLM API.
  """
  
  # For hackathon purposes, you could use OpenAI, but this could
  # also be mocked for testing/development
  
  # Simple function to call LLM API
  def call(prompt, opts \\ []) do
    # Configuration would typically come from application config
    api_key = Application.get_env(:bunq_investment, :openai_api_key)
    model = Keyword.get(opts, :model, "gpt-3.5-turbo")
    temperature = Keyword.get(opts, :temperature, 0.2)
    
    # This would be implemented using an HTTP client like Finch or Tesla
    # For the hackathon, a simple JSON response is returned
    
    # Mock response for development
    mock_response = %{
      choices: [
        %{
          message: %{
            content: ~s({
              "risk_bucket": "Balanced",
              "risk_score": 0.65,
              "reasoning": "Based on the transaction history, the user has a steady income and moderate spending habits. They save regularly but also have some discretionary spending, indicating a balanced approach to finances."
            })
          }
        }
      ]
    }
    
    # Parse the JSON from the response
    {:ok, Jason.decode!(mock_response.choices |> List.first() |> get_in([:message, :content]))}
  end
end
```

## Asset Data Integration

### Purpose
- Provide current market data for available investment assets
- Update portfolio valuations and return calculations

### Requirements
- **Asset Data**: Basic information about investment assets (ETFs, stocks, etc.)
- **Price Data**: Current and historical pricing information

### Implementation Approach
For the hackathon, we'll use hardcoded asset data:

```elixir
defmodule BunqInvestment.Assets.Repository do
  @moduledoc """
  Repository of available investment assets.
  """
  
  @doc """
  Returns a list of available assets for investment.
  """
  def list_available_assets do
    [
      %{
        symbol: "VTI",
        name: "Vanguard Total Stock Market ETF",
        asset_class: "Equity",
        current_price: 235.45,
        currency: "USD",
        market: "US",
        expected_yield: 0.068
      },
      %{
        symbol: "BND",
        name: "Vanguard Total Bond Market ETF",
        asset_class: "Bond",
        current_price: 72.35,
        currency: "USD",
        market: "US",
        expected_yield: 0.042
      },
      %{
        symbol: "VEA",
        name: "Vanguard FTSE Developed Markets ETF",
        asset_class: "Equity",
        current_price: 48.25,
        currency: "USD",
        market: "International",
        expected_yield: 0.065
      },
      %{
        symbol: "VWO",
        name: "Vanguard FTSE Emerging Markets ETF",
        asset_class: "Equity",
        current_price: 42.15,
        currency: "USD",
        market: "Emerging Markets",
        expected_yield: 0.078
      },
      %{
        symbol: "GLD",
        name: "SPDR Gold Shares",
        asset_class: "Commodity",
        current_price: 184.90,
        currency: "USD",
        market: "US",
        expected_yield: 0.015
      },
      %{
        symbol: "GOVT",
        name: "iShares U.S. Treasury Bond ETF",
        asset_class: "Government Bond",
        current_price: 22.75,
        currency: "USD",
        market: "US",
        expected_yield: 0.038
      },
      %{
        symbol: "SHY",
        name: "iShares 1-3 Year Treasury Bond ETF",
        asset_class: "Government Bond",
        current_price: 81.92,
        currency: "USD",
        market: "US",
        expected_yield: 0.032
      },
      %{
        symbol: "MUB",
        name: "iShares National Muni Bond ETF",
        asset_class: "Municipal Bond",
        current_price: 107.15,
        currency: "USD",
        market: "US",
        expected_yield: 0.035
      }
    ]
  end
end
```

## Frontend Integration

### Purpose
- Provide API endpoints for the frontend to consume
- Display user profiles, portfolios, and enable chat functionality

### Requirements
- **API Contracts**: Well-defined JSON contracts for all endpoints
- **Authentication**: API key validation for all endpoints
- **Error Handling**: Consistent error responses for frontend handling

### Authentication Flow
1. Frontend includes API key in X-API-Key header
2. Backend validates the API key
3. If valid, the request proceeds; if invalid, a 401 error is returned

### API Response Format
All successful responses will follow this format:
```json
{
  "data": { ... },
  "meta": {
    "timestamp": "2023-04-12T15:30:45Z"
  }
}
```

All error responses will follow the format defined in the Error Handling specification. 