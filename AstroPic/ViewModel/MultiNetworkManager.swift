import Foundation
import Combine
import UIKit

class MultiNetworkManager: ObservableObject {
    @Published var infos = [PhotoInfo]()
    @Published var daysFromToday: Int = 0
    
    private var subscription = Set<AnyCancellable>()
    
    init() {
        $daysFromToday
            .map { daysFromToday in
                API.createDate(daysFromToday: daysFromToday)
            }
            .map { date in
                API.createURL(for: date)
            }
            .flatMap { url in
                API.createPublisher(from: url)
            }
            .scan([]) { partialValue, newValue in
                partialValue + [newValue]
            }
            .tryMap { infos in
                infos.sorted { $0.formattedDate > $1.formattedDate }
            }
            .catch { error in
                Just([PhotoInfo]())
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \.infos, on: self)
            .store(in: &subscription)
        
        getMoreData(for: 24)
    }
    
    func getMoreData(for times: Int) {
        for i in 1 ..< times {
            daysFromToday += i
        }
    }
    
    func fetchImage(for photoInfo: PhotoInfo) {
        guard photoInfo.image == nil, let url = photoInfo.url else { return }
        URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
            if let error = error {
                print("Error fetching image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data), let index = self.infos.firstIndex(where: { $0.id == photoInfo.id }) else { return }
            DispatchQueue.main.async {
                self.infos[index].image = image
            }
            
        }.resume()
    }
}
