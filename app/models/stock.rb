require "httparty"
require "json"

class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    begin
      api_key = Rails.application.credentials.alphavantage_client[:api_key]

      # GLOBAL_QUOTE API çağrısı
      quote_response = HTTParty.get("https://www.alphavantage.co/query", {
        query: {
          function: "GLOBAL_QUOTE",
          symbol: ticker_symbol,
          apikey: api_key
        }
      })

      # SYMBOL_SEARCH API çağrısı
      search_response = HTTParty.get("https://www.alphavantage.co/query", {
        query: {
          function: "SYMBOL_SEARCH",
          keywords: ticker_symbol,
          apikey: api_key
        }
      })

      # Yanıtları ayrıştır
      quote_data = JSON.parse(quote_response.body)
      search_data = JSON.parse(search_response.body)

      # Şirket adı ve son fiyatı al
      latest_price = quote_data["Global Quote"]["05. price"].to_f
      company_name = search_data["bestMatches"]&.first&.dig("2. name") || "Unknown Company"

      # Yeni Stock nesnesi oluştur ve döndür
      new(ticker: ticker_symbol, name: company_name, last_price: latest_price)
    rescue StandardError => e
      Rails.logger.error "Error fetching stock data: #{e.message}"
      nil
    end
  end
end
