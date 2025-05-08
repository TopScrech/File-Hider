import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var isHideTargeted = false
    @State private var isUnhideTargeted = false
    
    var body: some View {
        HStack {
            VStack {
                Text("Hide")
                    .largeTitle()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onDrop(of: [.fileURL], isTargeted: $isHideTargeted) { providers in
                processFile(providers)
            }
            .background {
                if isHideTargeted {
                    Color.blue.opacity(0.5)
                }
            }
            
            VStack {
                Text("Unhide")
                    .largeTitle()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onDrop(of: [.fileURL], isTargeted: $isUnhideTargeted) { providers in
                processFile(providers, hide: false)
            }
            .background {
                if isUnhideTargeted {
                    Color.blue.opacity(0.5)
                }
            }
        }
    }
    
    private func processFile(
        _ providers: [NSItemProvider],
        hide: Bool = true
    ) -> Bool {
        for provider in providers {
            provider.loadItem(
                forTypeIdentifier: UTType.fileURL.identifier,
                options: nil
            ) { item, error in
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
                makeFileHidden(url, hide: hide)
            }
        }
        
        return true
    }
    
    private func makeFileHidden(_ url: URL, hide: Bool = true) {
        var resourceValues = URLResourceValues()
        resourceValues.isHidden = hide
        
        do {
            var modifiableURL = url
            try modifiableURL.setResourceValues(resourceValues)
        } catch {
            print("Error:", error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
