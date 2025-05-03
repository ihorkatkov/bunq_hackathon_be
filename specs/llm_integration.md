# LLM Integration Specification

This document outlines how the Bunq Investment Platform integrates with LLMs (Large Language Models) to provide investment advice.

## Overview

The platform uses two LLM-based agents:
1. **Risk Profile Agent**: Analyzes user transaction data to determine a risk profile
2. **Portfolio Suggestion Agent**: Creates portfolio recommendations based on the risk profile

## Agent Implementation

Both agents will be implemented as simple Elixir modules that format prompts, send them to an LLM API, and parse the responses.

```elixir
defmodule BunqInvestment.LLM.Client do
  @moduledoc """
  Client for interacting with the LLM API.
  """
  
  @doc """
  Sends a prompt to the LLM and returns the response.
  """
  def call(prompt, options \\ []) do
    # Implementation will depend on which LLM provider we use
    # For the hackathon, we could use OpenAI, Claude, or similar
  end
end
```

## Risk Profile Agent

### Purpose
Analyze transaction data to determine a user's risk profile and risk score.

### Input
The agent receives transaction data with:
- Transaction amounts
- Categories
- Merchants/counterparties
- Dates

### Output
```elixir
%{
  risk_bucket: :balanced, # :conservative, :balanced, :growth, or :aggressive
  risk_score: 0.65 # Float between 0 and 1
}
```

### Prompt Template
```
You are an investment advisor tasked with determining a client's risk profile based on their transaction history.

Analyze the following transactions and determine:
1. The client's risk bucket (Conservative, Balanced, Growth, or Aggressive)
2. A risk score from 0 to 1 (where 0 is most conservative and 1 is most aggressive)

Transaction History:
<transactions>
[
  {"amount": 45.50, "category": "Groceries", "counterparty": "Supermarket", "date": "2023-04-01"},
  {"amount": -2500.00, "category": "Income", "counterparty": "Employer", "date": "2023-04-01"},
  ...
]
</transactions>

Provide your analysis in the following JSON format:
{
  "risk_bucket": "Balanced",
  "risk_score": 0.65,
  "reasoning": "Brief explanation of your decision"
}
```

## Portfolio Suggestion Agent

### Purpose
Generate a recommended investment portfolio based on a user's risk profile, total balance, and available assets.

### Input
- Risk profile (bucket and score)
- Total balance
- Available assets (list of possible investment options)

### Output
```elixir
%{
  total_balance: 10000.00,
  rebalance_frequency_days: 90,
  assets: [
    %{
      symbol: "VTI",
      name: "Vanguard Total Stock Market ETF",
      asset_class: "Equity",
      weight: 0.60,
      current_price: 235.45,
      units: 25.48,
      currency: "USD",
      market: "US",
      price_date: ~D[2023-04-12],
      expected_yield: 0.068
    },
    # More assets...
  ]
}
```

### Prompt Template
```
You are an investment advisor tasked with creating a diversified portfolio based on a client's risk profile.

Client Profile:
- Risk Bucket: Balanced
- Risk Score: 0.65
- Total Balance: $10,000

Available Assets:
<assets>
[
  {"symbol": "VTI", "name": "Vanguard Total Stock Market ETF", "asset_class": "Equity", "current_price": 235.45, "currency": "USD", "market": "US", "expected_yield": 0.068},
  {"symbol": "BND", "name": "Vanguard Total Bond Market ETF", "asset_class": "Bond", "current_price": 72.35, "currency": "USD", "market": "US", "expected_yield": 0.042},
  ...
]
</assets>

Create a diversified portfolio that matches the client's risk profile. For a "Balanced" profile with score 0.65, suggest a moderate mix of stocks, bonds, and possibly some alternative investments.

Provide your recommendation in the following JSON format:
{
  "total_balance": 10000.00,
  "rebalance_frequency_days": 90,
  "assets": [
    {
      "symbol": "VTI",
      "name": "Vanguard Total Stock Market ETF",
      "asset_class": "Equity",
      "weight": 0.60,
      "current_price": 235.45,
      "units": 25.48,
      "currency": "USD",
      "market": "US",
      "expected_yield": 0.068
    },
    ... more assets ...
  ],
  "reasoning": "Brief explanation of your portfolio construction"
}
```

## Chat Interface Agent

### Purpose
Process natural language requests from users and generate appropriate responses, potentially updating the user's profile or portfolio.

### Input
- User message
- Current profile information
- Current portfolio information
- Chat history (limited to most recent messages)

### Output
```elixir
%{
  response: "I've adjusted your portfolio to reduce stock exposure from 60% to 40%, increasing bonds from 30% to 50%. This makes your profile more conservative. Your expected annual return is now 4.2% instead of 5.3%.",
  updated_profile: %{...}, # Optional
  updated_portfolio: %{...} # Optional
}
```

### Prompt Template
```
You are an AI investment advisor assistant that helps users understand and adjust their investment portfolios.

Current User Profile:
<profile>
{
  "risk_bucket": "Balanced",
  "risk_score": 0.65
}
</profile>

Current Portfolio:
<portfolio>
{
  "total_balance": 10000.00,
  "rebalance_frequency_days": 90,
  "assets": [
    {
      "symbol": "VTI",
      "name": "Vanguard Total Stock Market ETF",
      "asset_class": "Equity",
      "weight": 0.60,
      "current_price": 235.45,
      "units": 25.48,
      "currency": "USD",
      "market": "US",
      "expected_yield": 0.068
    },
    ... more assets ...
  ]
}
</portfolio>

Chat History:
<history>
User: How is my portfolio performing?
Assistant: Your portfolio has a balanced allocation with 60% in stocks, 30% in bonds, and 10% in gold. This is aligned with your balanced risk profile. The expected annual return is about 5.3%.
</history>

User Message: I'd like to reduce my exposure to stocks

Respond to the user's message. If they request changes to their portfolio or risk profile, include the updated information in your response in the format below.
If no changes are needed, only include the "response" field.

{
  "response": "Your friendly and helpful response explaining any changes",
  "updated_profile": { Risk profile changes if applicable },
  "updated_portfolio": { Portfolio changes if applicable }
}
```

## Implementation Considerations

For the hackathon, we'll keep the LLM integration simple:

1. Use a single LLM provider (OpenAI or similar)
2. Use simple JSON formatting for prompts and responses
3. Implement basic error handling for API failures
4. Cache responses to reduce API calls
5. Include safety measures to validate outputs (check that weights sum to 1, etc.) 