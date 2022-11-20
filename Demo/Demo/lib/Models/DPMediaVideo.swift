//
//  DPMediaVideo.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation
import UIKit

public struct DPMediaVideo {
    
    // MARK: - Init
    public init(
        url: URL,
        data: Data,
        preview: UIImage
    ) {
        self.url = url
        self.data = data
        self.preview = preview
    }
    
    // MARK: - Props
    public let url: URL
    public let data: Data
    public let preview: UIImage
    
}
