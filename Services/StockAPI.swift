import Foundation

class StockAPI {
    static let shared = StockAPI()

    private let apiKey = "YOUR_API_KEY"

    func fetchCurrentPrice(for symbol: String, completion: @escaping (Double?) -> Void) {
        // Replace with your chosen API endpoint
        let urlString = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(symbol)&apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL for stock symbol: \(symbol)")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching stock data: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data returned from stock API.")
                completion(nil)
                return
            }

            do {
                // Parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let globalQuote = json["Global Quote"] as? [String: Any],
                   let priceString = globalQuote["05. price"] as? String,
                   let price = Double(priceString) {
                    completion(price)
                } else {
                    print("Error parsing stock data.")
                    completion(nil)
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}
