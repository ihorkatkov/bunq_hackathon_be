# Data Models Specification

This document outlines the core data models for the Bunq Investment Platform.

## Database Schema

We'll use Ecto schemas to model our data with a PostgreSQL database backend.

## Core Schemas

### InvestorProfile

```elixir
defmodule BunqInvestment.Profiles.InvestorProfile do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "investor_profiles" do
    field :user_id, :binary_id
    field :risk_bucket, Ecto.Enum, values: [:conservative, :balanced, :growth, :aggressive]
    field :risk_score, :float
    
    timestamps()
  end
  
  def changeset(investor_profile, attrs) do
    investor_profile
    |> cast(attrs, [:user_id, :risk_bucket, :risk_score])
    |> validate_required([:user_id, :risk_bucket, :risk_score])
    |> validate_number(:risk_score, greater_than_or_equal_to: 0, less_than_or_equal_to: 1)
  end
end
```

### Portfolio

```elixir
defmodule BunqInvestment.Portfolios.Portfolio do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "portfolios" do
    field :user_id, :binary_id
    field :total_balance, :decimal
    field :rebalance_frequency_days, :integer
    
    has_many :assets, BunqInvestment.Portfolios.PortfolioAsset
    
    timestamps()
  end
  
  def changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [:user_id, :total_balance, :rebalance_frequency_days])
    |> validate_required([:user_id, :total_balance, :rebalance_frequency_days])
    |> validate_number(:total_balance, greater_than: 0)
    |> validate_number(:rebalance_frequency_days, greater_than: 0)
  end
end
```

### PortfolioAsset

```elixir
defmodule BunqInvestment.Portfolios.PortfolioAsset do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "portfolio_assets" do
    field :symbol, :string
    field :name, :string
    field :asset_class, :string
    field :weight, :decimal
    field :current_price, :decimal
    field :units, :decimal
    field :currency, :string
    field :market, :string
    field :price_date, :date
    field :expected_yield, :decimal
    
    belongs_to :portfolio, BunqInvestment.Portfolios.Portfolio, type: :binary_id
    
    timestamps()
  end
  
  def changeset(portfolio_asset, attrs) do
    portfolio_asset
    |> cast(attrs, [:symbol, :name, :asset_class, :weight, :current_price, :units, 
                    :currency, :market, :price_date, :expected_yield, :portfolio_id])
    |> validate_required([:symbol, :name, :asset_class, :weight, :current_price, 
                          :currency, :market, :price_date, :expected_yield, :portfolio_id])
    |> validate_number(:weight, greater_than: 0, less_than_or_equal_to: 1)
    |> validate_number(:current_price, greater_than: 0)
    |> validate_number(:expected_yield, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:portfolio_id)
  end
end
```

### Chat

```elixir
defmodule BunqInvestment.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "chat_messages" do
    field :user_id, :binary_id
    field :content, :string
    field :is_from_user, :boolean, default: true
    field :response_reference, :string
    
    timestamps()
  end
  
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user_id, :content, :is_from_user, :response_reference])
    |> validate_required([:user_id, :content, :is_from_user])
  end
end
```

### Transaction

```elixir
defmodule BunqInvestment.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "transactions" do
    field :user_id, :binary_id
    field :bunq_id, :string
    field :amount, :decimal
    field :description, :string
    field :counterparty, :string
    field :category, :string
    field :transaction_date, :date
    
    timestamps()
  end
  
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :bunq_id, :amount, :description, :counterparty, :category, :transaction_date])
    |> validate_required([:user_id, :bunq_id, :amount, :transaction_date])
  end
end
```

## Database Migrations

Example migration for creating the investor profiles table:

```elixir
defmodule BunqInvestment.Repo.Migrations.CreateInvestorProfiles do
  use Ecto.Migration

  def change do
    create table(:investor_profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :binary_id, null: false
      add :risk_bucket, :string, null: false
      add :risk_score, :float, null: false
      
      timestamps()
    end

    create index(:investor_profiles, [:user_id])
  end
end
```

## Context Modules

For the hackathon version, we'll organize our functionality into these contexts:

1. `BunqInvestment.Profiles` - For managing investor profiles
2. `BunqInvestment.Portfolios` - For portfolio management
3. `BunqInvestment.Transactions` - For transaction processing
4. `BunqInvestment.Chat` - For chat interface
5. `BunqInvestment.LLM` - For LLM integration 