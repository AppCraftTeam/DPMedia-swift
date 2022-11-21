//
//  DPMediaDataGenerator.swift
//  Demo
//
//  Created by Дмитрий Поляков on 21.11.2022.
//

import Foundation
import UIKit

public struct DPMediaDataGenerator {
    
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
    public func generate(_ url: URL) throws -> Data {
        do {
            let data = try Data(contentsOf: url)
            try self.checkFileType(data)
            try self.checkMaxSize(data)
            return data
        } catch {
            throw error
        }
    }
    
    public func generatePNG(_ image: UIImage) throws -> Data {
        do {
            guard let data = image.pngData() else {
                throw DPMediaError.failureImage
            }
            try self.checkFileType(data)
            try self.checkMaxSize(data)
            return data
        } catch {
            throw error
        }
    }
    
    public func checkFileType(_ data: Data) throws {
        guard !self.allowsFileTypes.isEmpty else { return }
        guard let fileType = DPMediaMimeType(data: data)?.fileType else { return }
        guard !self.allowsFileTypes.contains(fileType) else { return }
        throw DPMediaError.fileTypeNotSupported
    }
    
    public func checkMaxSize(_ data: Data) throws {
        guard  let maxSizeMB = self.maxSizeMB else { return }
        guard (Double(data.count) / 1000 / 1024) > maxSizeMB else { return }
        throw DPMediaError.maxSizeMB(maxSizeMB)
    }
    
}
