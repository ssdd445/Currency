import Foundation

enum APIConstants {
    private var baseURL: String { return "http://data.fixer.io/api" }
    private var accessKey: String { return "e00895374411f4cfcc7d637a78dc74bf" }
    
    case rates
    case history(date: String, currencies: String)
    
    private var fullPath: String {
        var endpoint:String
        switch self {
        case .rates:
            endpoint = "/latest?access_key=\(accessKey)"
        case .history(let date, let currencies):
            endpoint = "/\(date)?access_key=\(accessKey)&symbols=\(currencies)"
        }
        return baseURL + endpoint
    }
    
    var url: URL {
        guard let url = URL(string: fullPath) else {
            preconditionFailure("The url used in \(APIConstants.self) is not valid")
        }
        return url
    }
}
