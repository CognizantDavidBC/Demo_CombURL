import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            APODListView()
                .navigationTitle(Text("APIC"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
