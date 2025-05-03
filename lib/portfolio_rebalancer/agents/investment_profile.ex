defmodule PortfolioRebalancer.Agents.InvestmentProfile do
  @moduledoc """
  Analyzes a user's spending and saving behavior to determine their investment profile.
  """

  alias LangChain.ChatModels.ChatOpenAI
  alias LangChain.Chains.LLMChain
  alias LangChain.Message
  alias LangChain.Utils.ChainResult

  @doc """
  Returns the investment profile for a user based on their transactions.
  """
  def get_investment_profile!(transactions) do
    {:ok, chain} =
      LLMChain.new!(%{
        llm:
          ChatOpenAI.new!(%{
            model: "gpt-4.1-2025-04-14",
            temperature: 0.7,
            verbose_api: false
          }),
        verbose: false
      })
      |> LLMChain.add_message(Message.new_system!(promt(transactions)))
      |> LLMChain.run()

    Jason.decode!(ChainResult.to_string!(chain))
  end

  defp promt(transactions) do
    """
    You are a financial AI tasked with analyzing a user's spending and saving behavior.
    Given their bank transaction data, classify them into a risk profile:
    'Conservative', 'Balanced', or 'Aggressive'.
    Also give a risk_score between 0 (very conservative) and 1 (very aggressive).
    Here are the transactions:
    #{inspect(transactions)}

    Response format:
    {
      "risk_profile": "Conservative",
      "risk_score": 0.1
    }
    """
  end
end
