# Security Specification

Given the limited timeframe of the hackathon, we'll implement basic but effective security measures for the Bunq Investment Platform.

## Authentication

### API Key Authentication
- All API requests require a valid API key in the `X-API-Key` header
- API keys should be unique per user and sufficiently long (32+ characters)
- Keys should be stored hashed in the database, not in plaintext

```elixir
defmodule BunqInvestment.Auth.ApiKey do
  use Ecto.Schema
  import Ecto.Changeset
  alias BunqInvestment.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "api_keys" do
    field :key_hash, :string
    field :name, :string
    field :key, :string, virtual: true
    field :expires_at, :utc_datetime
    
    belongs_to :user, User, type: :binary_id
    
    timestamps()
  end
  
  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:name, :key, :expires_at, :user_id])
    |> validate_required([:name, :key, :user_id])
    |> put_key_hash()
    |> unique_constraint(:key_hash)
  end
  
  defp put_key_hash(%Ecto.Changeset{valid?: true, changes: %{key: key}} = changeset) do
    put_change(changeset, :key_hash, Bcrypt.hash_pwd_salt(key))
  end
  
  defp put_key_hash(changeset), do: changeset
end
```

### API Key Validation Plug
A Phoenix plug will be used to validate API keys on protected routes:

```elixir
defmodule BunqInvestmentWeb.Plugs.ApiAuth do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "x-api-key") do
      [api_key] -> verify_api_key(conn, api_key)
      _ -> unauthorized(conn)
    end
  end

  defp verify_api_key(conn, api_key) do
    case BunqInvestment.Auth.verify_api_key(api_key) do
      {:ok, user} ->
        assign(conn, :current_user, user)
      _ ->
        unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> put_view(BunqInvestmentWeb.ErrorView)
    |> render(:"401")
    |> halt()
  end
end
```

## Data Security

### Sensitive Data Handling
- Financial transaction data should be treated as sensitive
- Database encryption for sensitive fields using `cloak_ecto`
- TLS for all API communication

### User Data Protection
- User identifiers should be non-sequential UUIDs
- No storage of Bunq credentials/tokens in plain text
- Limited retention period for transaction data

## API Security

### Rate Limiting
Basic rate limiting to prevent abuse:

```elixir
defmodule BunqInvestmentWeb.Plugs.RateLimit do
  import Plug.Conn
  import Phoenix.Controller
  
  def init(opts), do: opts
  
  def call(conn, _opts) do
    # Simple in-memory rate limiting for the hackathon
    # In production, would use Redis or similar
    case ExRated.check_rate("api:#{client_ip(conn)}", 60_000, 100) do
      {:ok, _} -> conn
      {:error, _} -> rate_limited(conn)
    end
  end
  
  defp client_ip(conn), do: conn.remote_ip |> Tuple.to_list |> Enum.join(".")
  
  defp rate_limited(conn) do
    conn
    |> put_status(:too_many_requests)
    |> put_view(BunqInvestmentWeb.ErrorView)
    |> render(:"429")
    |> halt()
  end
end
```

### Input Validation
- All request parameters validated through Ecto changesets
- JSON schema validation for complex input structures
- Whitelist approach to parameter acceptance

## LLM Security

### Prompt Injection Prevention
- Sanitize user input before inclusion in LLM prompts
- Use proper templating with clear separation of user data
- Validate LLM responses before processing them

### Data Minimization
- Only send necessary transaction data to LLMs
- No identifying information in prompts
- Filter sensitive transaction details before analysis

## Implementation Priorities

For the 4-hour hackathon, we'll focus on:

1. API key authentication - highest priority
2. Basic input validation
3. Simple rate limiting
4. Response validation from LLM

Future enhancements (post-hackathon):
- OAuth 2.0 integration
- Database encryption
- Comprehensive audit logging
- Advanced rate limiting and throttling 