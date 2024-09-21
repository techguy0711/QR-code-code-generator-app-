//
//  StoredQRCodesScreen.swift
//  QRServer
//
//  Created by Kristhian De Oliveira on 9/21/24.
//

import SwiftUI
import SwiftData

struct Faves: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var queryQRs: [QRStore]
    @State private var qRs: [QRStore] = []
    
    @ViewBuilder
    var noFavesView: some View {
        VStack(alignment: .center) {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Text("🙁")
                        .scaleEffect(CGSize(width: 5.0, height: 5.0))
                        .padding(50)
                    Text("No favorites yet!")
                        .font(.title)
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    var favesListView: some View {
        List {
            ForEach($qRs, id: \.id, editActions: .delete) { qr in
                VStack {
                    if let text = qr.text.wrappedValue {
                        HStack {
                            Text(text)
                                .font(.headline)
                            Spacer()
                        }
                    }
                    if let data = qr.imageData.wrappedValue {
                        Image(uiImage: UIImage(data: data)!)
                    }
                }
            }.onDelete(perform: { indexSet in
                deleteItems(offsets: indexSet)
                qRs = queryQRs
            })
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                if queryQRs.isEmpty {
                    noFavesView
                } else {
                    favesListView
                }
            }.navigationTitle("Favorites")
                .onAppear {
                    qRs = queryQRs
                }
        }
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(qRs[index])
            }
        }
    }
}

#Preview {
    Faves()
}
