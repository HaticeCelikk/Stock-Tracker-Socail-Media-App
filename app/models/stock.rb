require "httparty"
require "json"

class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    begin
      api_key = Rails.application.credentials.alphavantage_client[:api_key]
      response = HTTParty.get("https://www.alphavantage.co/query", {
        query: {
          function: "GLOBAL_QUOTE",
          symbol: ticker_symbol,
          apikey: api_key
        }
      })

      data = JSON.parse(response.body)
      latest_price = data["Global Quote"]["05. price"].to_f
      latest_price

    rescue StandardError => e
      puts "Hata oluştu: #{e.message}"
      nil
    end
  end
end
