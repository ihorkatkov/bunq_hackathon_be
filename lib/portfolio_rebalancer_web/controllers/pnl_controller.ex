defmodule PortfolioRebalancerWeb.PnlController do
  use PortfolioRebalancerWeb, :controller
  use OpenApiSpex.ControllerSpecs

  operation(:get_pnl,
    tags: ["PnL"],
    summary: "Get PnL",
    description: "Get PnL for a given portfolio",
    operationId: "PnlController.get_pnl",
    responses: [
      ok: {"PnL retrieved successfully", "application/json", PortfolioRebalancerWeb.Schemas.Pnl}
    ]
  )

  def get_pnl(conn, _params) do
    json(conn, generate_pnl_data(Date.utc_today()))
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
            balance: last_balance.balance + last_balance.balance * (abs(i) * coef),
            netReturn: abs(i) * coef
          }

          {next_balance, [next_balance | acc]}
        end
      )

    Enum.reverse(pnl_data)
  end
end
