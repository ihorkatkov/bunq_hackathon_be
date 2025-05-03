# Bunq Investment Platform - Backend Specification

AI-powered investment platform that leverages Bunq banking data to create personalized investment profiles and recommendations.

## Executive Summary
Bunq Investment Coach is an AI-powered investment advisory platform that demystifies investment decisions for everyday banking customers. Developed during a one-day hackathon in partnership with Bunq, this solution analyzes users' transaction histories to create personalized investment profiles and portfolio recommendations. The platform features an intuitive chat interface that allows users to understand and adjust their investment strategies in natural language, making investing accessible to everyone regardless of financial literacy level.

## Problem Statement
Investing remains intimidating and complex for average consumers:

Many individuals lack confidence in selecting appropriate investments
Traditional advisory services are expensive and inaccessible
Most people don't understand how their spending patterns relate to investment potential
Investment terminology and concepts create significant barriers to entry
Timing investment decisions feels like guesswork for novice investors

## Our Solution
Bunq Investment Coach bridges the gap between banking and investing by:

Analyzing existing financial behavior through Bunq transaction data
Generating personalized investment profiles based on spending patterns
Recommending optimized portfolios aligned with user risk tolerance
Providing an AI chat interface for investment guidance and adjustments
Visualizing potential returns to make abstract concepts tangible

## Backend Architecture

### Technology Stack
- **Authentication**: API Key-based (X-API-Key header)

### Core Components

#### 1. API Service
- RESTful API implementation following OpenAPI 3.0.3 specification
- Endpoints structured around profile → portfolio → chat workflow
- JSON-based request/response formats
- Error handling with standardized error codes

#### 2. Data Processing Engine
- Transaction data ingestion from Bunq API
- Data cleaning and normalization
- Feature extraction for ML models

#### 3. ML Analysis System
- Risk profile generation based on transaction patterns
- Portfolio optimization algorithms
- Return projection models
- CAGR and yield prediction

#### 4. Chat Interface Backend
- Natural language processing for user requests
- Context-aware response generation
- Portfolio and profile update capabilities

### API Endpoints

Based on the provided OpenAPI specification:

#### 1. Profile Management
- **GET /investor-profile**
  - Returns the user's investment profile including:
    - Risk bucket categorization (Conservative, Balanced, Growth, Aggressive)
    - Risk score (0-1 scale)
  - Authentication: API Key

#### 2. Portfolio Management
- **GET /portfolio**
  - Returns recommended portfolio including:
    - Total balance
    - Asset allocation (symbols, weights, prices)
    - Rebalancing frequency
    - Asset details (class, expected yield, current price)
  - Authentication: API Key

#### 3. Chat Interface
- **POST /chat**
  - Request body: User message text
  - Response: AI-generated reply with optional updated profile and portfolio
  - Authentication: API Key

### Data Models

#### InvestorProfile
- userId (UUID)
- riskBucket (enum: Conservative, Balanced, Growth, Aggressive)
- riskScore (float: 0-1)
- lastUpdated (datetime)

#### Portfolio
- userId (UUID)
- totalBalance (float)
- rebalanceFrequencyDays (integer)
- assets (array of PortfolioAsset objects)
- lastUpdated (datetime)

#### PortfolioAsset
- symbol (string)
- name (string)
- assetClass (string)
- weight (float)
- currentPrice (float)
- units (float)
- currency (string)
- market (string)
- priceDate (date)
- expectedYield (float)

#### PnlPoint
- date (date)
- balance (float)
- netReturn (float)

### Implementation Considerations

#### Security
- API key validation and management

#### Error Handling
- Standardized error responses with appropriate HTTP status codes
- Detailed logging for debugging
- Graceful degradation for service dependencies

#### Integration Requirements
- Bunq API connection for transaction data
- Market data provider for asset pricing

## Success Criteria
- Functional API with all specified endpoints
- Realistic investment profiles based on transaction data
- Diversified portfolio recommendations
- Interactive chat interface that can modify user profiles
- Clean integration with frontend components