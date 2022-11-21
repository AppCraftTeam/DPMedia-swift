//
//  DPMediaImage.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation
import UIKit

public struct DPMediaImage {
    
    // MARK: - Init
    public init(
        fileName: String,
        fileExtension: String,
        data: Data,
        image: UIImage
    ) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.data = data
        self.image = image
    }
    
    // MARK: - Props
    public let fileName: String
    public let fileExtension: String
    public let data: Data
    public let image: UIImage
}
