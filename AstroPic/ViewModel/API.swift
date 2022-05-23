import Foundation
import Combine

struct API {
    static func createURL(for date: Date) -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let url = URL(string: Constants.baseURL)!
        let fullUrl = url.withQuery(["api_key": Constants.key, "date": formatter.string(for: date)!])!
        
        return fullUrl
    }
    
    static func createDate(daysFromToday: Int) -> Date {
        let today = Date()
        
        if let date = Calendar.current.date(byAdding: .day, value: -daysFromToday, to: today) {
            return date
        }
        return today
    }
    
    static func createPublisher(from url: URL) -> AnyPublisher<PhotoInfo, Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PhotoInfo.self, decoder: JSONDecoder())
            .catch { error in
                Just(PhotoInfo())
            }
            .eraseToAnyPublisher()
    }
}
