//
//  ContentView.swift
//  QRServer
//
//  Created by Kristhian De Oliveira on 9/21/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = QRServerModel()
    @State private var showSizePicker: Bool = false
    
    var SizePicker: some View {
        Picker("Size:", selection: $model.size) {
            ForEach((100...350).filter { $0 % 25 == 0 }, id: \.self) { size in
                Text("\(size)X\(size)")
            }
        }
    }
    
    var saveButton: some View {
        Button(action: {
            model.saveImage()
        }) {
            Image(systemName: "square.and.arrow.down")
            Text("Save")
        }
    }
    
    var body: some View {
        NavigationView {
            LazyVStack {
                if model.isLoading {
                    VStack {
                        ProgressView()
                        Text("Loading...")
                    }
                }
                if let image = model.QRImage {
                    Image(uiImage: image)
                }
                HStack {
                    saveButton
                    SizePicker
                }
            }
            .padding()
            .searchable(text: $model.text, placement: .navigationBarDrawer, prompt: "Enter text to generate QR code")
            .onSubmit(of: .search, {
                model.generateQRImage()
            })
            .onChange(of: $model.size.wrappedValue, {
                model.generateQRImage()
            })
            .navigationTitle("QR Code Generator")
        }
        .onAppear {
            model.text = "Hello, World!"
            model.generateQRImage()
        }
    }
}

#Preview {
    ContentView()
}
