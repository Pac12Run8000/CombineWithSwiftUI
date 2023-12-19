import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    @Published var data:Data?
    @Published var acronymObject:AcronymObject?
    @Published var list:[String] = []
    var cancellables:Set<AnyCancellable> = []
    
    @Published var listItems = ["Item 1", "Item 2", "Item 3"]

    func submitAction(input: String) {
        print("Submit button tapped with input: \(input)")
        listItems.append(input)
    }
    
    func populateListInView(search:String?) {
        var localList = [String]()
        guard let search = search, let url = URLComponentConstants.createURLWithComponents(queryParameters: [URLQueryName.sf.rawValue:search])?.url else {
            print(ResponseError.invalidUrl.description)
            return
        }
        
        let promise = NetworkingService.shared.fetchAPIResponse(url: url)
        let acronym = promise.decode(type: AcronymObject.self, decoder: JSONDecoder())
        acronym.sink { (completion) in
            if case let .failure(error) = completion {
                print("ViewModel Error: \(error.localizedDescription)")
            }
        } receiveValue: { [weak self] acronym in
            guard let strongself = self else {return}
            strongself.acronymObject = acronym
            for item in acronym[0].lfs {
                localList.append(item.lf)
            }
            strongself.list = localList
        }.store(in: &cancellables)
    }
}
