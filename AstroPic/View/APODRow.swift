import SwiftUI

struct APODRow: View {
    let photoInfo: PhotoInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(photoInfo.date).bold()
            Text(photoInfo.title)
        }
    }
}

struct APODRow_Previews: PreviewProvider {
    static var previews: some View {
        APODRow(photoInfo: PhotoInfo.createDefault())
    }
}