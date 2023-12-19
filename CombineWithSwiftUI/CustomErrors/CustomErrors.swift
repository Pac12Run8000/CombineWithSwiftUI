import Foundation

enum ParseError:Error {
    case modelNotMatchingData
}

enum ModelError:Error {
    case jsonParsError
}

enum ResponseError:Error {
    case noData
    case noUrl
    case badStatusCode
    case badResponse
    case invalidUrl
}

extension ModelError:CustomStringConvertible {
    var description: String {
        switch self {
        case .jsonParsError:
            return "The Codeable model isn't compatable with the JSON response."
        }
    }
}


extension ResponseError:CustomStringConvertible {
    var description: String {
        switch self {
        case .noData:
            return "There is no response from the given url."
        case .noUrl:
            return "No url was passed to the api call."
        case .badStatusCode:
            return "The status code was not 200 so there is an issue with the response."
        case .badResponse:
            return "There is an error with the data task."
        case .invalidUrl:
            return "A malformed url was passed"
        }
    }
    
    
}


extension ParseError:CustomStringConvertible {
    var description: String {
        switch self {
        case .modelNotMatchingData:
            return "The data isn't match the model."
        }
    }
    
    
}
