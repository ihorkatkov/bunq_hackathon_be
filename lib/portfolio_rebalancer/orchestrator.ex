defmodule PortfolioRebalancer.Orchestrator do
  @moduledoc """
  Orchestrates the portfolio rebalancing process.
  """
  use GenServer

  alias PortfolioRebalancer.Agents.InvestmentProfile

  def get_investment_profile do
    GenServer.call(__MODULE__, :get_investment_profile)
  end

  def get_pnl do
    GenServer.call(__MODULE__, :get_pnl)
  end

  def get_balance do
    GenServer.call(__MODULE__, :get_balance)
  end

  def refresh do
    GenServer.cast(__MODULE__, :refresh)
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{investment_profile: nil, pnl: nil, balance: nil}, {:continue, :init}}
  end

  @spec handle_continue(:init, %{:investment_profile => any(), optional(any()) => any()}) ::
          {:noreply, %{:investment_profile => any(), optional(any()) => any()}}
  def handle_continue(:init, state) do
    transactions = Jason.encode!(PortfolioRebalancer.Bunq.get_transactions())
    investment_profile = InvestmentProfile.get_investment_profile!(transactions)
    pnl = PortfolioRebalancer.Pnl.pnl(Date.utc_today())
    balance = Map.get(List.last(pnl), :balance)

    {:noreply, %{state | investment_profile: investment_profile, pnl: pnl, balance: balance}}
  end

  def handle_call(:get_investment_profile, _from, state) do
    {:reply, state.investment_profile, state}
  end

  def handle_call(:get_pnl, _from, state) do
    {:reply, state.pnl, state}
  end

  def handle_call(:get_balance, _from, state) do
    {:reply, Float.round(state.balance, 2), state}
  end

  def handle_cast(:refresh, state) do
    {:noreply, state, {:continue, :init}}
  end
end
