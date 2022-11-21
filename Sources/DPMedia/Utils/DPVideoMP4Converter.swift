//
//  DPVideoMP4Converter.swift
//  Demo
//
//  Created by Дмитрий Поляков on 21.11.2022.
//

import Foundation
import AVFoundation

public struct DPVideoMP4Converter {
    
    public func convert(_ url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let asset = AVURLAsset(url: url, options: nil)
        let fileManager = FileManager.default
        
        guard
            let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough),
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            completion(.failure(DPMediaError.failureVideo))
            return
        }
        
        let fileName = (url.lastPathComponent as NSString).deletingPathExtension
        let filePath = documentsDirectory.appendingPathComponent("\(fileName).mp4")
        
        if fileManager.fileExists(atPath: filePath.path) {
            do {
                try fileManager.removeItem(at: filePath)
            } catch {
                completion(.failure(error))
            }
        }
        
        exportSession.outputURL = filePath
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: asset.duration)
        exportSession.timeRange = range
        
        exportSession.exportAsynchronously(completionHandler: {
            switch exportSession.status {
            case .failed:
                completion(.failure(exportSession.error ?? DPMediaError.someError))
            case .cancelled:
                completion(.failure(DPMediaError.cancel))
            case .completed:
                if let outputURL = exportSession.outputURL {
                    completion(.success(outputURL))
                } else {
                    completion(.failure(DPMediaError.someError))
                }
            default:
                break
            }
        })
    }
    
}
