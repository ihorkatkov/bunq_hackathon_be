# API Endpoints Specification

## Authentication
All API endpoints require authentication using an API key passed in the `X-API-Key` header.

## Base URL
The base URL for all API endpoints is: `/api/v1`

## Endpoints

### 1. Profile Management

#### GET /investor-profile
Returns the user's investment profile based on transaction analysis.

**Request**
- Headers: 
  - `X-API-Key`: User API key

**Response**
```json
{
  "userId": "550e8400-e29b-41d4-a716-446655440000",
  "riskBucket": "Balanced",
  "riskScore": 0.65,
  "lastUpdated": "2023-04-12T15:30:45Z"
}
```

**Status Codes**
- `200 OK`: Profile successfully retrieved
- `401 Unauthorized`: Invalid API key
- `404 Not Found`: Profile not found
- `500 Internal Server Error`: Server error

### 2. Portfolio Management

#### GET /portfolio
Returns the recommended portfolio based on the user's risk profile.

**Request**
- Headers:
  - `X-API-Key`: User API key

**Response**
```json
{
  "userId": "550e8400-e29b-41d4-a716-446655440000",
  "totalBalance": 10000.00,
  "rebalanceFrequencyDays": 90,
  "assets": [
    {
      "symbol": "VTI",
      "name": "Vanguard Total Stock Market ETF",
      "assetClass": "Equity",
      "weight": 0.60,
      "currentPrice": 235.45,
      "units": 25.48,
      "currency": "USD",
      "market": "US",
      "priceDate": "2023-04-12",
      "expectedYield": 0.068
    },
    {
      "symbol": "BND",
      "name": "Vanguard Total Bond Market ETF",
      "assetClass": "Bond",
      "weight": 0.30,
      "currentPrice": 72.35,
      "units": 41.46,
      "currency": "USD",
      "market": "US",
      "priceDate": "2023-04-12",
      "expectedYield": 0.042
    },
    {
      "symbol": "GLD",
      "name": "SPDR Gold Shares",
      "assetClass": "Commodity",
      "weight": 0.10,
      "currentPrice": 184.90,
      "units": 5.41,
      "currency": "USD",
      "market": "US",
      "priceDate": "2023-04-12",
      "expectedYield": 0.015
    }
  ],
  "lastUpdated": "2023-04-12T15:30:45Z"
}
```

**Status Codes**
- `200 OK`: Portfolio successfully retrieved
- `401 Unauthorized`: Invalid API key
- `404 Not Found`: Portfolio not found
- `500 Internal Server Error`: Server error

### 3. Chat Interface

#### POST /chat
Processes a user message and returns an AI-generated response.

**Request**
- Headers:
  - `X-API-Key`: User API key
- Body:
```json
{
  "message": "I'd like to reduce my exposure to stocks"
}
```

**Response**
```json
{
  "response": "I've adjusted your portfolio to reduce stock exposure from 60% to 40%, increasing bonds from 30% to 50%. This makes your profile more conservative. Your expected annual return is now 4.2% instead of 5.3%.",
  "updatedProfile": {
    "userId": "550e8400-e29b-41d4-a716-446655440000",
    "riskBucket": "Conservative",
    "riskScore": 0.42,
    "lastUpdated": "2023-04-12T15:45:30Z"
  },
  "updatedPortfolio": {
    "userId": "550e8400-e29b-41d4-a716-446655440000",
    "totalBalance": 10000.00,
    "rebalanceFrequencyDays": 90,
    "assets": [
      {
        "symbol": "VTI",
        "name": "Vanguard Total Stock Market ETF",
        "assetClass": "Equity",
        "weight": 0.40,
        "currentPrice": 235.45,
        "units": 16.99,
        "currency": "USD",
        "market": "US",
        "priceDate": "2023-04-12",
        "expectedYield": 0.068
      },
      {
        "symbol": "BND",
        "name": "Vanguard Total Bond Market ETF",
        "assetClass": "Bond",
        "weight": 0.50,
        "currentPrice": 72.35,
        "units": 69.11,
        "currency": "USD",
        "market": "US", 
        "priceDate": "2023-04-12",
        "expectedYield": 0.042
      },
      {
        "symbol": "GLD",
        "name": "SPDR Gold Shares",
        "assetClass": "Commodity",
        "weight": 0.10,
        "currentPrice": 184.90,
        "units": 5.41,
        "currency": "USD",
        "market": "US",
        "priceDate": "2023-04-12",
        "expectedYield": 0.015
      }
    ],
    "lastUpdated": "2023-04-12T15:45:30Z"
  }
}
```

**Status Codes**
- `200 OK`: Message processed successfully
- `400 Bad Request`: Invalid message format
- `401 Unauthorized`: Invalid API key
- `500 Internal Server Error`: Server error

## Implementation Notes
- All endpoints should return JSON responses
- Error responses should include a `message` field with a human-readable error description
- Timestamps should be in ISO 8601 format
- Phoenix router will be configured to handle these endpoints
- API versioning is included in the URL path for future compatibility 