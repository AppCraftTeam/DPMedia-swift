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
        data: Data,
        image: UIImage
    ) {
        self.data = data
        self.image = image
    }
    
    // MARK: - Props
    public let data: Data
    public let image: UIImage
}
