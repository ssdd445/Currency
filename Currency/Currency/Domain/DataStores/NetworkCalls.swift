import Foundation

final class NetworkCalls {
    static func getHistoricalData(currencies: String, date: String, completion: @escaping (Result<History, Error>) -> Void) {
        guard Reachability.shared.isConnected else {
            completion(.failure(MyError.customError(Constants.InternetIssues)))
            return
        }
        
        let urlRequest = URLRequest(url: APIConstants.history(date: date, currencies: currencies).url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(MyError.customError(Constants.DataError)))
                return
            }
            
            do {
                let history = try JSONDecoder().decode(History.self, from: data)
                completion(.success(history))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func getLatestCurrencyRates(completion: @escaping (Result<Rate, Error>) -> Void) {
        guard Reachability.shared.isConnected else {
            completion(.failure(MyError.customError(Constants.InternetIssues)))
            return
        }
        let urlRequest = URLRequest(url: APIConstants.rates.url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(MyError.customError(Constants.DataError)))
                return
            }
            
            do {
                let rate = try JSONDecoder().decode(Rate.self, from: data)
                completion(.success(rate))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}
