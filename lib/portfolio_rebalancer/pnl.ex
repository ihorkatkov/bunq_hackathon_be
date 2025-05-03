defmodule PortfolioRebalancer.Pnl do
  @moduledoc """
  Provides functions to interact with the PNL data.
  """

  @doc """
  Returns the PNL data for a given date.
  """
  def pnl(date) do
    generate_pnl_data(date)
  end

  defp generate_pnl_data(date) do
    {_last_balance, pnl_data} =
      Enum.reduce(
        -29..0,
        {%{balance: 10000.00, netReturn: 0.015}, []},
        fn i, {last_balance, acc} ->
          random = -3..5 |> Enum.map(fn x -> x * 0.0001 end)
          coef = Enum.random(random)

          next_balance = %{
            date: Date.to_string(Date.add(date, i)),
            balance:
              Float.round(last_balance.balance + last_balance.balance * (abs(i) * coef), 2),
            netReturn: abs(i) * coef
          }

          {next_balance, [next_balance | acc]}
        end
      )

    Enum.reverse(pnl_data)
  end
end
