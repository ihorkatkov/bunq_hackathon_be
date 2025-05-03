defmodule PortfolioRebalancerWeb.ErrorJSONTest do
  use PortfolioRebalancerWeb.ConnCase, async: true

  test "renders 404" do
    assert PortfolioRebalancerWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert PortfolioRebalancerWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
