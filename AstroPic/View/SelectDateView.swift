import SwiftUI

struct SelectDateView: View {
    @ObservedObject var manager: NetworkManager
    @Environment(\.presentationMode) var presentation
    @State private var date = Date()
    
    var body: some View {
        VStack {
            Text("Select a day")
            
            DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                Text("Select")
            }.labelsHidden()
            
            Button {
                self.manager.date = date
                self.presentation.wrappedValue.dismiss()
            } label: {
                Text("Done")
            }
        }
    }
}

struct SelectDateView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDateView(manager: NetworkManager())
    }
}
