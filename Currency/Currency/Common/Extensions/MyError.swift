import Foundation

enum MyError: LocalizedError {
    case customError(String)

    var localizedDescription: String {
        switch self {
        case .customError(let message):
            return "\(message)"

        }
    }
}
