import SwiftUI

struct DayPicView: View {
    @ObservedObject var manager = NetworkManager()
    @State private var showSwitchDate = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button {
                showSwitchDate.toggle()
            } label: {
                Image(systemName: "calendar")
                Text("Switch day")
            }
            .padding(.trailing)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .popover(isPresented: $showSwitchDate) {
                SelectDateView(manager: manager)
            }
            
            if let image = manager.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 300)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(manager.photoInfo.date).font(.title)
                    Text(manager.photoInfo.title).font(.headline)
                    Text(manager.photoInfo.description)
                }
            }
            .padding()
        }
    }
}

struct DayPicView_Previews: PreviewProvider {
    static var previews: some View {
        let view = DayPicView()
        view.manager.image = UIImage(systemName: "photo")
        view.manager.photoInfo = PhotoInfo.createDefault()
        return view
    }
}
