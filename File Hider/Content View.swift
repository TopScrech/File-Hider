import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var isTargeted = false
    
    var body: some View {
        VStack {
            Text("Goida")
        }
        .background {
            if isTargeted {
                Color.blue.opacity(0.2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
            for provider in providers {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                    if let error {
                        print("Error:", error)
                        return
                    }
                    
                    guard
                        let data = item as? Data,
                        let url = NSURL(
                            absoluteURLWithDataRepresentation: data,
                            relativeTo: nil
                        ) as URL?
                    else {
                        return
                    }
                    
                    print(url.path)
                }
            }
            
            return true
        }
    }
}

#Preview {
    ContentView()
}
