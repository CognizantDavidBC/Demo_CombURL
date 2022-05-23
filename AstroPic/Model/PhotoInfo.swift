import UIKit

struct PhotoInfo: Codable, Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var url: URL?
    var copyright: String?
    var date: String
    var image: UIImage?
    
    var formattedDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self.date) ?? Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "explanation"
        case url = "url"
        case copyright = "copyright"
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        self.description = try valueContainer.decode(String.self, forKey: CodingKeys.description)
        self.url = try? valueContainer.decode(URL.self, forKey: CodingKeys.url)
        self.copyright = try? valueContainer.decode(String.self, forKey: CodingKeys.copyright)
        self.date = try valueContainer.decode(String.self, forKey: CodingKeys.date)
    }
    
    init() {
        self.description = ""
        self.title = ""
        self.date = ""
    }
    
    static func createDefault() -> PhotoInfo {
        var photoInfo = PhotoInfo()
        photoInfo.title = "Jupiter's Swimming Storm"
        photoInfo.description = "A bright storm head a long turbulent wake swims across Juputer in these sharp telescopic images of the Solar System"
        photoInfo.date = "2022-05-24"
        return photoInfo
    }
}
