//
//  Fav.swift
//  QRServer
//
//  Created by Kristhian De Oliveira on 9/21/24.
//

import Foundation
import SwiftData

@Model
public final class QRStore {
    var text: String?
    var imageData: Data?
    
    init(text: String? = nil, imageData: Data? = nil) {
        self.text = text
        self.imageData = imageData
    }
}

