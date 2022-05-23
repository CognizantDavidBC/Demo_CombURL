import SwiftUI

struct APODListView: View {
    @ObservedObject var manager = MultiNetworkManager()
    
    var body: some View {
        List {
            ForEach(manager.infos) { info in
                NavigationLink(destination: APODDetailView(manager: manager, photoInfo: info)) {
                    APODRow(photoInfo: info)
                }
                .onAppear {
                    if let index = manager.infos.firstIndex(where: { $0.id == info.id }),
                       index == manager.infos.count - 1 && manager.daysFromToday == manager.infos.count - 1 {
                        manager.getMoreData(for: 10)
                    }
                }
            }
        }
    }
}

struct APODListView_Previews: PreviewProvider {
    static var previews: some View {
        APODListView()
    }
}
