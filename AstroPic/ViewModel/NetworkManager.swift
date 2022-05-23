import UIKit
import Combine

class NetworkManager: ObservableObject {
    @Published var photoInfo = PhotoInfo()
    @Published var image: UIImage?
    @Published var date = Date()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $date
            .removeDuplicates()
            .sink { _ in
                self.image = nil
            }
            .store(in: &subscriptions)
        
        $date
            .removeDuplicates()
            .map {
                self.createURL(for: $0)
            }
            .flatMap { url in
                URLSession.shared.dataTaskPublisher(for: url)
                    .map(\.data)
                    .decode(type: PhotoInfo.self, decoder: JSONDecoder())
                    .catch { error in
                        Just(PhotoInfo())
                    }
            }
            .receive(on: RunLoop.main)
            .assign(to: \.photoInfo, on: self)
            .store(in: &subscriptions)
        
        $photoInfo
            .filter { $0.url != nil }
            .map { photoInfo -> URL in
                return photoInfo.url!
            }
            .flatMap { url in
                URLSession.shared.dataTaskPublisher(for: url)
                    .map(\.data)
                    .catch { error in
                        Just(Data())
                    }
            }
            .map { output -> UIImage? in
                UIImage(data: output)
            }
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: self)
            .store(in: &subscriptions)
        
        
        
        //            .sink { completion in
        //                switch completion {
        //                case .finished:
        //                    print("Fetch complete: FINISHED")
        //                case .failure(let failure):
        //                    print("Fetch complete: FAILURE - \(failure)")
        //                }
        //            } receiveValue: { data, response in
        //                if let description =  String(data: data, encoding: .utf8) {
        //                    print("Fetched data - \(description)")
        //                }
        //            }.store(in: &subscriptions)
        
    }
    
    private func createURL(for date: Date) -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let url = URL(string: Constants.baseURL)!
        let fullUrl = url.withQuery(["api_key": Constants.key, "date": formatter.string(for: date)!])!
        
        return fullUrl
    }
}
