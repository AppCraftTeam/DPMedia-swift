//
//  DPMediaPNGImageProcessor.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation
import UIKit

public struct DPMediaPNGImageProcessor: DPMediaImageProcessorFactory {
    
    // MARK: - Init
    public init(allowsFileTypes: Set<DPFileType>? = nil) {
        self.allowsFileTypes = allowsFileTypes
    }
    
    // MARK: - Props
    public let allowsFileTypes: Set<DPFileType>?
    
    // MARK: - Methods
    public func process(_ image: UIImage) throws -> DPMediaImage {
        do {
            guard let data = image.pngData() else {
                throw DPMediaError.failureImage
            }
            
            try self.checkFileType(data)
            
            return DPMediaImage(
                data: data,
                image: image
            )
            
        } catch {
            throw error
        }
    }
    
    public func checkFileType(_ data: Data) throws {
        guard let allowsFileTypes = self.allowsFileTypes else { return }
        
        if let fileType = DPMimeType(data: data)?.fileType, allowsFileTypes.contains(fileType) {
            return
        } else {
            throw DPMediaError.imageTypeNotSupported
        }
    }
    
}
