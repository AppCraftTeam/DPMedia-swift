//
//  DPMediaVideoProcessor.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation
import UIKit

public struct DPMediaVideoProcessor: DPMediaVideoProcessorFactory {
    
    // MARK: - Init
    public init(
        maxSizeMB: Double? = nil,
        allowsFileTypes: Set<DPMediaFileType> = []
    ) {
        self.maxSizeMB = maxSizeMB
        self.allowsFileTypes = allowsFileTypes
    }
    
    // MARK: - Props
    public let maxSizeMB: Double?
    public let allowsFileTypes: Set<DPMediaFileType>
    
    // MARK: - Methods
    public func process(_ url: URL, completion: @escaping (Result<DPMediaVideo, Error>) -> Void) {
        do {
            let data = try Data(contentsOf: url)
            try DPMediaMaxSizeChecker(maxSizeMB: self.maxSizeMB).checkData(data)
            try DPMediaFileTypeChecker(allowsFileTypes: self.allowsFileTypes).checkData(data)
            
            let preview = try DPVideoPreviewGenerator().generate(from: url)
            let fileName = url.lastPathComponent
            let fileExtension = (fileName as NSString).pathExtension
            
            let successVideo = DPMediaVideo(
                fileName: fileName,
                fileExtension: fileExtension,
                url: url,
                data: data,
                preview: preview
            )
            
            completion(.success(successVideo))
        } catch {
            completion(.failure(error))
        }
    }
    
}
