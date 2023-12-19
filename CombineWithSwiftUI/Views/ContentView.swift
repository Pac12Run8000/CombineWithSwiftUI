import SwiftUI

struct ContentView: View {
    @State private var inputText: String = ""
    @ObservedObject var viewModel = ContentViewModel()
    var body: some View {
        VStack {
            HStack {
                TextField("Enter text", text: $inputText)
                    .padding()
                    .border(Color.gray, width: 1)
                    .padding()
                
                Button(action: {
                    viewModel.populateListInView(search: inputText)
                }) {
                    Text("Submit")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            List(viewModel.list, id: \.self) { item in
                Text(item)
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
