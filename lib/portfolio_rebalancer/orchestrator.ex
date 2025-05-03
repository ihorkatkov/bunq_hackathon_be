defmodule PortfolioRebalancer.Orchestrator do
  @moduledoc """
  Orchestrates the portfolio rebalancing process.
  """
  use GenServer

  alias PortfolioRebalancer.Agents.InvestmentProfile

  def get_investment_profile do
    GenServer.call(__MODULE__, :get_investment_profile)
  end

  def refresh do
    GenServer.cast(__MODULE__, :refresh)
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{investment_profile: nil}, {:continue, :init}}
  end

  @spec handle_continue(:init, %{:investment_profile => any(), optional(any()) => any()}) ::
          {:noreply, %{:investment_profile => any(), optional(any()) => any()}}
  def handle_continue(:init, state) do
    transactions = Jason.encode!(PortfolioRebalancer.Bunq.get_transactions())
    investment_profile = InvestmentProfile.get_investment_profile!(transactions)

    {:noreply, %{state | investment_profile: investment_profile}}
  end

  def handle_call(:get_investment_profile, _from, state) do
    {:reply, state.investment_profile, state}
  end

  def handle_cast(:refresh, state) do
    {:noreply, state, {:continue, :init}}
  end
end
