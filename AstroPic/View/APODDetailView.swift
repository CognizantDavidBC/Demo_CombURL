import SwiftUI

struct APODDetailView: View {
    @ObservedObject var manager: MultiNetworkManager
    let photoInfo: PhotoInfo
    
    init(manager: MultiNetworkManager, photoInfo: PhotoInfo) {
        self.manager = manager
        self.photoInfo = photoInfo
    }
    
    var body: some View {
        VStack {
            if let image = photoInfo.image {
                NavigationLink(destination: InteractiveImageView(image: image)) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }.buttonStyle(PlainButtonStyle())
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 60)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(photoInfo.title).font(.headline)
                    Text(photoInfo.description)
                }
            }
            .padding()
        }
        .navigationBarTitle(Text(photoInfo.date), displayMode: .inline)
        .onAppear {
            manager.fetchImage(for: photoInfo)
        }
    }
}

struct APODDetailView_Previews: PreviewProvider {
    static var previews: some View {
        APODDetailView(manager: MultiNetworkManager(), photoInfo: PhotoInfo())
    }
}
