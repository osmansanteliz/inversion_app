require 'httparty'

class CryptoApi
	include HTTParty
	base_uri 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'

	headers 'X-CMC_PRO_API_KEY' => 'a84d8dee-2f2b-4de2-bed3-3bf0e47e061f'

	def get_crypto_listings
    response = self.class.get('https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest')
    if response.success?
    	response.parsed_response
    else
    	raise "Error al obtener los datos de la API"
    end		
  end

end