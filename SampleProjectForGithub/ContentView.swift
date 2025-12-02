import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Swift Coding Club")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.red)
            Button(action: {
            }) {
                Text("Button")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(20)
            }
            
            
        }
        .padding(20)
    }
}

#Preview {
    ContentView()
}
