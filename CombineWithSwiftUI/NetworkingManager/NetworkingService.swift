import Foundation
import Combine

class NetworkingService {
    
    public static let shared = NetworkingService()
    var cancellables:Set<AnyCancellable> = []
    
    private init() {}
    
    public func fetchAPIResponse(url:URL) -> Future<Data, Error> {
        return Future<Data, Error> {  promise in
            
            URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .tryMap { (data, response) -> Data in
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...300) ~= statusCode else {
                        throw ResponseError.badStatusCode
                    }
                    return data
                }
                .sink { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let urLError as URLError:
                            promise(.failure(urLError))
                        default:
                            promise(.failure(ResponseError.invalidUrl))
                        }
                    }
                    
                } receiveValue: { data in
                    promise(.success(data))
                }
                .store(in: &self.cancellables)

            }
        
    }
    
}
