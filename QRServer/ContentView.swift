//
//  ContentView.swift
//  QRServer
//
//  Created by Kristhian De Oliveira on 9/21/24.
//

import SwiftUI
import SwiftData

public struct ContentView: View {
    @ObservedObject var model = QRServerModel()
    @State var showSizePicker: Bool = false
    @State var showSaveSuccess: Bool = false
    @Environment(\.modelContext) var modelContext
    @Query var faves: [QRStore]

    var SizePicker: some View {
        Picker("Size:", selection: $model.size) {
            ForEach((100...350).filter { $0 % 25 == 0 }, id: \.self) { size in
                Text("\(size)X\(size)")
                    .tag(size)
                    .padding()
            }
        }
        .frame(width: UIScreen.main.bounds.width/1.2, height: 55)
        .foregroundStyle(.white)
        .background(
            RoundedRectangle(
                cornerSize: .init(width: 16, height: 16)
            ).fill(.black)
        )
    }
    
    var saveButton: some View {
        Button(action: {
            model.saveImage()
            showSaveSuccess = true
        }) {
            HStack(spacing: 12) {
                Image(systemName: "square.and.arrow.down")
                Text("Save")
            }.padding()
        }
        .frame(width: UIScreen.main.bounds.width/1.2)
        .foregroundStyle(.white)
        .background(
            RoundedRectangle(
                cornerSize: .init(width: 16, height: 16)
            ).fill(.green)
        )
        //Alert with Image saved, and ok button
        .alert(isPresented: $showSaveSuccess) {
            Alert(title: Text("Image Saved"), message: Text("Your image has been saved to your camera roll."), dismissButton: .default(Text("OK")))
        }
    }
    
    var addFavoriteButton: some View {
        Button(action: {
            modelContext.insert(QRStore(text: model.text, imageData: model.QRImage?.pngData()))
        }) {
            Image(systemName: "star.fill")
            Text("Add to Favorites")
        }
        .frame(width: UIScreen.main.bounds.width/1.2, height: 55)
        .foregroundStyle(.white)
        .background(
            RoundedRectangle(
                cornerSize: .init(width: 16, height: 16)
            ).fill(.blue)
        )
    }
    
    public var body: some View {
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
                VStack(spacing: 16) {
                    saveButton
                    SizePicker
                    addFavoriteButton
                }.padding(.top)
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
