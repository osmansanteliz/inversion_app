require 'csv'

class InvestmentsController < ApplicationController
	def new
    @investment = Investment.new
    coin_market_api = CryptoApi.new
    @crypto_listings = coin_market_api.get_crypto_listings

    @bitcoin_data = @crypto_listings["data"].find { |crypto| crypto["symbol"] == "BTC" }
    @ethereum_data = @crypto_listings["data"].find { |crypto| crypto["symbol"] == "ETH" }
    
  end

  def show
    @investment = Investment.find(params[:id])

    coin_market_api = CryptoApi.new
    @crypto_listings = coin_market_api.get_crypto_listings
    @bitcoin_data = @crypto_listings["data"].find { |crypto| crypto["symbol"] == "BTC" }
    @ethereum_data = @crypto_listings["data"].find { |crypto| crypto["symbol"] == "ETH" }

    @bitcoin_amount = @investment.amount / @bitcoin_data['quote']['USD']['price']
    @ethereum_amount = @investment.amount / @ethereum_data['quote']['USD']['price']

    bitcoin_interest_rate = 0.05
    ethereum_interest_rate = 0.03

    @bitcoin_projection_monthly = @investment.amount * (1 + bitcoin_interest_rate)
    @bitcoin_projection_annual = @investment.amount * (1 + bitcoin_interest_rate)**12

    @ethereum_projection_monthly = @investment.amount * (1 + ethereum_interest_rate)
    @ethereum_projection_monthly = @investment.amount * (1 + ethereum_interest_rate)**12
  end

  def create
    @investment = Investment.new(investment_params)
    coin_market_api = CryptoApi.new
    @crypto_listings = coin_market_api.get_crypto_listings
    @bitcoin_data = @crypto_listings["data"].find { |crypto| crypto["symbol"] == "BTC" }
    @ethereum_data = @crypto_listings["data"].find { |crypto| crypto["symbol"] == "ETH" }
    
    if @investment.save
      @bitcoin_amount = @investment.amount / @bitcoin_data['quote']['USD']['price']
      @ethereum_amount = @investment.amount / @ethereum_data['quote']['USD']['price']
      redirect_to action: :show, id: @investment.id
    else
      render :new
    end
  end

  def export_csv
    @investment = Investment.find(params[:id])
    @bitcoin_interest_rate = 0.05
    @ethereum_interest_rate = 0.03
    @investment.amount

    @bitcoin_projection_monthly = @investment.amount * (1 + @bitcoin_interest_rate)
    @bitcoin_projection_annual = @investment.amount * (1 + @bitcoin_interest_rate)**12

    @ethereum_projection_monthly = @investment.amount * (1 + @ethereum_interest_rate)
    @ethereum_projection_annual = @investment.amount * (1 + @ethereum_interest_rate)**12

    csv_data = CSV.generate do |csv|
      csv << ["Monto", "Moneda", "Proyección Mensual", "Proyección Anual"]
      csv << [@investment.amount, "Bitcoin (BTC)", @bitcoin_projection_monthly, @bitcoin_projection_annual]
      csv << [@investment.amount, "Ethereum (ETH)", @ethereum_projection_monthly, @ethereum_projection_annual]
    end
    send_data csv_data, filename: "proyeccion.csv"
  end

  def export_json
    @investment = Investment.find(params[:id])
    @bitcoin_interest_rate = 0.05
    @ethereum_interest_rate = 0.03
    @investment.amount

    @bitcoin_projection_monthly = @investment.amount * (1 + @bitcoin_interest_rate)
    @bitcoin_projection_annual = @investment.amount * (1 + @bitcoin_interest_rate)**12

    @ethereum_projection_monthly = @investment.amount * (1 + @ethereum_interest_rate)
    @ethereum_projection_annual = @investment.amount * (1 + @ethereum_interest_rate)**12

    json_data = {
      "Bitcoin (BTC)" => {
        "Monto Inversion" => @investment.amount,
        "Proyección Mensual" => @bitcoin_projection_monthly,
        "Proyección Anual" => @bitcoin_projection_annual
      },
      "Ethereum (ETH)" => {
        "Monto Inversion" => @investment.amount,
        "Proyección Mensual" => @ethereum_projection_monthly,
        "Proyección Anual" => @ethereum_projection_annual
      }
    }

    send_data json_data.to_json, filename: "proyeccion.json"
  end

  private

  def investment_params
    params.require(:investment).permit(:amount)
  end

end
