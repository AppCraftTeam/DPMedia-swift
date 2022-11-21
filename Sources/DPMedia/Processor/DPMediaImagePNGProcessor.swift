//
//  DPMediaImagePNGProcessor.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation
import UIKit

public struct DPMediaImagePNGProcessor: DPMediaImageProcessorFactory {
   
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
    public func process(_ image: UIImage, completion: @escaping (Result<DPMediaImage, Error>) -> Void) {
        do {
            let data = try DPMediaDataGenerator(
                maxSizeMB: self.maxSizeMB,
                allowsFileTypes: self.allowsFileTypes
            ).generatePNG(image)
            
            let successVideoImage = DPMediaImage(
                fileName: UUID().uuidString,
                fileExtension: DPMediaFileType.png.rawValue,
                data: data,
                image: image
            )
            
            completion(.success(successVideoImage))
        } catch {
            completion(.failure(error))
        }
    }
    
}
