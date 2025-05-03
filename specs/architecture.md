# Architecture Specification

## Technology Stack
- **Backend**: Elixir/Phoenix
- **Database**: PostgreSQL
- **Authentication**: API Key-based (X-API-Key header)
- **LLM Integration**: Using LLMs for risk profiling and portfolio suggestions
- **Additional Tools**: Tailwind CSS, Sobelow, Credo, Ecto, ExUnit, Plug, Phoenix LiveView

## System Components

### 1. API Service
- RESTful API implementation following OpenAPI 3.0.3 specification
- Endpoints structured around profile → portfolio → chat workflow
- JSON-based request/response formats
- Error handling with standardized error codes
- Implementation using Phoenix framework

### 2. Transaction Processing
- Simple transaction data ingestion from Bunq API
- Basic data cleaning and categorization
- Ecto schemas for data persistence
- Modular design for future extensibility

### 3. LLM-based Analysis
- **Risk Profile Agent**: Analyzes transaction data to determine risk profile and score
- **Portfolio Suggestion Agent**: Uses risk profile, balance, and available assets to suggest a portfolio
- No complex ML models or algorithms
- Simple prompt templates for consistent outputs

### 4. Chat Interface Backend
- Simple context-aware response generation
- Portfolio and profile update capabilities
- Stateful conversations through database persistence
- Integration with frontend components

## Component Interaction
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│                 │    │                 │    │                 │
│  Bunq API       │───>│  Transaction    │───>│  Risk Profile   │
│                 │    │  Processing     │    │  Agent (LLM)    │
└─────────────────┘    └─────────────────┘    └────────┬────────┘
                                                       │
                                                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│                 │    │                 │    │                 │
│  Frontend UI    │<───│  API Service    │<───│  Portfolio      │
│                 │    │                 │    │  Agent (LLM)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
        ▲                      ▲
        │                      │
        └──────────────────────┘
             Chat Interface
```

## Data Flow
1. User authenticates via API key
2. Backend requests transaction data from Bunq API
3. Transaction data is processed and analyzed by the Risk Profile Agent
4. Risk profile is passed to Portfolio Agent along with available assets
5. Portfolio recommendations are generated and stored
6. User interacts with the system via API endpoints or chat interface
7. Updates to profile and portfolio are persisted to database

## Scalability Considerations
For the hackathon, we focus on a simple implementation. Future scaling could include:
- Caching layer for frequent requests
- Background job processing for LLM requests
- Scheduled portfolio rebalancing tasks
- Real-time asset price updates 