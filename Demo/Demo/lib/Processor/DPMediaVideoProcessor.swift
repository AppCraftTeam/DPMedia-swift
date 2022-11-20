//
//  DPMediaVideoProcessor.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation
import AVFoundation
import UIKit

public struct DPMediaVideoProcessor: DPMediaVideoProcessorFactory {
    
    // MARK: - Init
    public init(allowsFileTypes: Set<DPFileType>? = nil) {
        self.allowsFileTypes = allowsFileTypes
    }
    
    // MARK: - Props
    public let allowsFileTypes: Set<DPFileType>?
    
    // MARK: - Methods
    public func process(_ url: URL) throws -> DPMediaVideo {
        do {
            let data = try Data(contentsOf: url)
            try self.checkFileType(data)
            let asset = AVURLAsset(url: url, options: nil)
            
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let preview = UIImage(cgImage: cgImage)
            
            return DPMediaVideo(
                url: url,
                data: data,
                preview: preview
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
