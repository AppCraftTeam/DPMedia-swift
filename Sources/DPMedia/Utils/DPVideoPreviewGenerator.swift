//
//  DPVideoPreviewGenerator.swift
//  Demo
//
//  Created by Дмитрий Поляков on 21.11.2022.
//

import Foundation
import AVFoundation
import UIKit

public struct DPVideoPreviewGenerator {
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Props
    public func generate(from url: URL) throws -> UIImage {
        let asset = AVURLAsset(url: url, options: nil)
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let preview = UIImage(cgImage: cgImage)
            return preview
        } catch {
            throw error
        }
    }
}
 
