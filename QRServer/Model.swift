//
//  File.swift
//  QRServer
//
//  Created by Kristhian De Oliveira on 9/21/24.
//

import Foundation
import Combine
import SwiftUI

// combine model
class QRServerModel: ObservableObject {
    @Published var text: String = ""
    @Published var QRImage: UIImage?
    @Published var isLoading: Bool = false
    @Published var size: Int = 250
    
    var cancellables = Set<AnyCancellable>()
    
    func generateQRImage() {
        guard !text.isEmpty else { return }
        isLoading = true
        URLSession.shared.dataTaskPublisher(for: .init(string: "https://api.qrserver.com/v1/create-qr-code/?data=\(text)&size=\(size)x\(size)")!)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure:
                    print("Failure")
                }
            }, receiveValue: { data in
                self.QRImage = UIImage(data: data)
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func saveImage() {
        if let image = QRImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
