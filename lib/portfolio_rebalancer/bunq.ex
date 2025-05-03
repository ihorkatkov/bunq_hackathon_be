defmodule PortfolioRebalancer.Bunq do
  @moduledoc """
  Provides functions to interact with the Bunq API.
  """

  @doc """
  Returns the transactions for the current user.
  """
  def get_transactions do
    # Generate 10-20 random transactions
    Enum.map(1..Enum.random(10..20), fn _ -> generate_transaction() end)
  end

  defp generate_transaction do
    # Randomly decide if this is an aggressive or conservative profile
    profile = Enum.random([:aggressive, :conservative])

    %{
      "id" => Enum.random(1_000_000..9_999_999),
      "created" => random_date(),
      "updated" => random_date(),
      "monetary_account_id" => Enum.random(10000..99999),
      "amount" => random_amount(profile),
      "alias" => random_alias(),
      "counterparty_alias" => random_counterparty(profile),
      "description" => random_description(profile),
      "type" => random_transaction_type(profile),
      "sub_type" => random_sub_type(profile),
      "balance_after_mutation" => random_balance(profile),
      # Include only essential fields for the investment profile analysis
      "merchant_reference" =>
        Enum.random(["INV-#{Enum.random(1000..9999)}", "REF-#{Enum.random(1000..9999)}", nil])
    }
  end

  # Generate random date within last 90 days
  defp random_date do
    days_ago = Enum.random(0..90)
    today = Date.utc_today()
    date = Date.add(today, -days_ago)
    time = Time.new!(Enum.random(0..23), Enum.random(0..59), Enum.random(0..59))
    datetime = DateTime.new!(date, time, "Etc/UTC")
    DateTime.to_iso8601(datetime)
  end

  # Generate different amount ranges based on profile
  defp random_amount(:aggressive) do
    %{
      "value" => "#{Enum.random([-1, -1, -1, 1]) * Enum.random(500..10000) / 100}",
      "currency" => Enum.random(["EUR", "USD"])
    }
  end

  defp random_amount(:conservative) do
    %{
      "value" => "#{Enum.random([-1, -1, 1, 1]) * Enum.random(50..2000) / 100}",
      "currency" => "EUR"
    }
  end

  defp random_alias do
    %{
      "iban" =>
        "NL#{Enum.random(10..99)}BUNQ#{String.pad_leading("#{Enum.random(1_000_000..9_999_999)}", 9, "0")}",
      "display_name" => "My BUNQ Account",
      "is_light" => false
    }
  end

  defp random_counterparty(:aggressive) do
    company =
      Enum.random([
        "eToro",
        "Binance",
        "Coinbase",
        "Interactive Brokers",
        "Robinhood",
        "TD Ameritrade",
        "Saxo Bank",
        "DeGiro",
        "Crypto.com",
        "BlockFi",
        "FTX",
        "Kraken"
      ])

    %{
      "iban" =>
        "#{Enum.random(["DE", "GB", "FR", "US"])}#{Enum.random(10..99)}#{String.pad_leading("#{Enum.random(1_000_000..9_999_999)}", 10, "0")}",
      "display_name" => company
    }
  end

  defp random_counterparty(:conservative) do
    company =
      Enum.random([
        "Vanguard",
        "Fidelity",
        "BlackRock",
        "Charles Schwab",
        "ING Bank",
        "ABN AMRO",
        "Rabobank",
        "BNP Paribas",
        "HSBC",
        "Santander",
        "Nordea",
        "Intesa Sanpaolo"
      ])

    %{
      "iban" =>
        "#{Enum.random(["NL", "DE", "FR", "IT"])}#{Enum.random(10..99)}#{String.pad_leading("#{Enum.random(1_000_000..9_999_999)}", 10, "0")}",
      "display_name" => company
    }
  end

  defp random_description(:aggressive) do
    Enum.random([
      "Investment in tech stocks",
      "Cryptocurrency purchase",
      "High-yield bond fund",
      "Emerging markets ETF",
      "Options trading fee",
      "Margin trading deposit",
      "NFT purchase",
      "Growth stock portfolio",
      "Leveraged ETF investment",
      "Angel investing platform",
      "Startup equity purchase",
      "High-risk mutual fund"
    ])
  end

  defp random_description(:conservative) do
    Enum.random([
      "Savings deposit",
      "Government bond purchase",
      "Blue-chip dividend stock",
      "CD renewal",
      "Treasury bill investment",
      "Index fund contribution",
      "Municipal bond purchase",
      "Retirement account transfer",
      "Low-risk mutual fund",
      "Fixed-income investment",
      "Value stock portfolio",
      "High-grade corporate bond"
    ])
  end

  defp random_transaction_type(:aggressive) do
    Enum.random([
      "INVESTMENT",
      "TRADING",
      "DEPOSIT",
      "WITHDRAWAL",
      "FEE"
    ])
  end

  defp random_transaction_type(:conservative) do
    Enum.random([
      "INVESTMENT",
      "SAVINGS",
      "DEPOSIT",
      "WITHDRAWAL",
      "INTEREST",
      "DIVIDEND"
    ])
  end

  defp random_sub_type(:aggressive) do
    Enum.random([
      "STOCKS",
      "CRYPTO",
      "FOREX",
      "OPTIONS",
      "FUTURES",
      "MARGIN",
      "ETF"
    ])
  end

  defp random_sub_type(:conservative) do
    Enum.random([
      "BOND",
      "INDEX_FUND",
      "SAVINGS",
      "CD",
      "TREASURY",
      "DIVIDEND",
      "PENSION"
    ])
  end

  defp random_balance(:aggressive) do
    # More volatile balances for aggressive profiles
    %{
      "value" => "#{Enum.random(5000..50000) / 100}",
      "currency" => Enum.random(["EUR", "USD"])
    }
  end

  defp random_balance(:conservative) do
    # More stable balances for conservative profiles
    %{
      "value" => "#{Enum.random(10000..30000) / 100}",
      "currency" => "EUR"
    }
  end
end
