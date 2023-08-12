require "test_helper"

class InvestmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_investment_url
    assert_response :success
    assert_includes response.body, "<h1>Calcular Inversión</h1>"
  end

  test "should show investment" do
    investment = investments(:one)
    get investment_url(investment)
    assert_response :success
    assert_includes response.body, "<h1>Resultados de la Inversión</h1>"
  end

  test "should create investment" do
    assert_difference('Investment.count') do
      post investments_url, params: { investment: { amount: 1000 } }
    end

    assert_redirected_to investment_url(Investment.last)
  end

  test "should export CSV" do
    investment = investments(:one)
    get export_csv_investment_url(investment)
    assert_response :success
    assert_equal 'text/csv', response.content_type
    assert_match /Monto,Moneda,Proyección Mensual,Proyección Anual/, response.body
  end

  test "should export JSON" do
    investment = investments(:one)
    get export_json_investment_url(investment)
    assert_response :success
    assert_equal 'application/json', response.content_type

    json_response = JSON.parse(response.body)
    assert_equal "9.99", json_response["Bitcoin (BTC)"]["Monto Inversion"]
  end
end
